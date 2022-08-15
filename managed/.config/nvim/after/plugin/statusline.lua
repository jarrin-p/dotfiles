--- @author jarrin-p
--- @file `snippets.lua`
LS = require 'luasnip'

--- symbols {{{
local symbols = {
    bl = '«', -- bracket left
    br = '»', -- bracket right
    ra = '->', -- right ..arrow
    left_tr = '◢',
    right_tr = '◣',
}
--
-- local enter_sym = '⏎'
-- local te = '⋯'
-- end symbols }}}

--- highlight group wrapper {{{
--- nvim highlight group wrapper that allows easier inline status text formatting.
-- additionally, has defaults specified to keep the status line uniform
SLColorgroup = {
    name = 'Not set',
    scope = 0,
    options = {
        underline = 1, -- underline needs to be enabled for custom underline color.
        sp = Colors.gui.gray, -- default for the underline color.
    },
    pretext = '',
    posttext = '',

    --- create new statusline colorgroup object. attempting to manage statusline color groups
    -- so its behavior can be more easily updated.
    new = function(self, arg_table)
        self.__index = self
        local obj = {}
        setmetatable(obj, self)

        for key, val in pairs(arg_table) do
            if key == 'options' then
                -- if it's the options table, loop through to add to the table instead of
                -- overwriting from the new table. this preserves default settings.
                for opts_key, opts_val in pairs(val) do
                    obj.options[opts_key] = opts_val
                end

            else
                obj[key] = val
            end
        end
        vim.api.nvim_set_hl(obj.scope, obj.name, obj.options)
        return obj
    end,

    --- returns the string to use the color group in the status line.
    -- @param text_to_color [optional] for code readability, to "pseudo" wrap the group of characters to be colored.
    set = function(self, text_to_color)
        text_to_color = text_to_color or ''
        return '%#' .. self.name .. '#' .. self.pretext .. text_to_color
                   .. self.posttext
    end,
}
-- end highlight group wrapper }}}

--- color groups {{{
-- create custom color groups for the status line. assigning them to variables
-- allows the color groups to have a `set` helper function that uses defaults.
local bracket = SLColorgroup:new{
    name = 'SLBracket',
    options = { bold = 0, ctermfg = 8, fg = Colors.gui.gray },
}
local sl_item = SLColorgroup:new{
    name = 'SLItem',
    options = { ctermfg = 121, fg = Colors.gui.green_bright },
}
local directory = SLColorgroup:new{
    name = 'SLDir',
    options = { italic = 1, ctermfg = 3, fg = Colors.gui.wood_dark },
}
local header = SLColorgroup:new{
    name = 'SLFileHeader',
    options = { bold = 0, italic = 0, ctermfg = 11,
    fg = Colors.gui.green_bright },
}
local mod = SLColorgroup:new{
    name = 'SLModified',
    options = { italic = 0, ctermfg = 9, fg = Colors.gui.red },
}
-- end custom color groups }}}

--- functions {{{
--- gets the absolute path of the currently worked on file using `expand`
--- and splits it into a table.
--- @return table abs_file_table an ordered table containing each directory for the path.
function GetAbsolutePathAsTable()
    local abs_file_path = {}
    for match in vim.fn.expand('%:p'):sub(1):gmatch('/[^/]*') do
        table.insert(abs_file_path, (match:gsub('/', '')))
    end
    return abs_file_path
end

--- standard linear search function.
--- @param table_to_search table the table to be searched.
--- @param item_to_find any item to be found in the table.
--- @return number index of item. returns `-1` if nothing is found.
function LinearSearch(table_to_search, item_to_find)
    for i, item in ipairs(table_to_search) do
        if item == item_to_find then
            return i
        end
    end
    return -1
end

--- build the path itself.
function MakePath()
    local file_type = vim.api.nvim_get_option_value('filetype', {})
    local buf_type = vim.api.nvim_get_option_value('buftype', {})

    if buf_type == 'terminal' then
        return header:set 'Terminal'

    elseif file_type == 'help' then
        return header:set 'Help'

    elseif file_type == 'qf' then
        return header:set 'Quick Fix || Location List'

    elseif file_type == 'fugitive' then
        return header:set 'Fugitive ' .. bracket:set(symbols.bl)
                   .. directory:set ' Git'

    elseif file_type == 'gitcommit' then
        return header:set 'Commit ' .. bracket:set(symbols.bl)
                   .. directory:set ' Fugitive ' .. bracket:set(symbols.bl)
                   .. directory:set ' Git'

    elseif file_type == 'git' then
        return header:set 'Branch ' .. bracket:set(symbols.bl)
                   .. directory:set ' Fugitive ' .. bracket:set(symbols.bl)
                   .. directory:set ' Git'

    elseif file_type == 'nerdtree' then
        return (sl_item:set '↟' .. header:set 'NERDTree')

    elseif vim.fn.FugitiveIsGitDir() == 1 then
        local abs_file_path = GetAbsolutePathAsTable()

        local _, last_index = vim.fn.FugitiveWorkTree():find('.*/')
        local index_of_dir = LinearSearch(
            abs_file_path,
                (vim.fn.FugitiveWorkTree():sub(last_index):gsub('/', ''))
        )

        local status = ConvertTableToPathString(abs_file_path, 5, index_of_dir)
        return status
    else
        local status = ConvertTableToPathString(GetAbsolutePathAsTable(), 5)
        return status
    end
end

--- takes the path and converts it to a string that will be set on the statusline.
--- @param path_table table to be converted to status.
--- @param truncate_point? number on the status line.
--- @param project_root_index? number directory of the project root
function ConvertTableToPathString(
    path_table, truncate_point, project_root_index
)
    if not path_table then
        return 'no path to convert'
    end
    truncate_point = truncate_point or #path_table
    project_root_index = project_root_index or 1

    local status, reverse_path = '', {}
    for i = #path_table, project_root_index, -1 do
        table.insert(reverse_path, path_table[i])
    end

    -- while there's more than one entry left to add to the path that will be displayed
    while (#reverse_path > 1) do
        -- pop the next item to be displayed in the path from the stack and add a bracket
        local pop = directory:set(table.remove(reverse_path))
        if #reverse_path < truncate_point then
            status = pop .. status
            status = ' ' .. bracket:set(symbols.bl) .. ' ' .. status

            -- set the point where truncation occurs on the list
        elseif #path_table == truncate_point then
            status = ' ' .. bracket:set(symbols.bl) .. directory:set ' <% '
        end
    end

    --- the `open` file itself is the last item in the table to be popped.
    -- additionally, adds a modified symbol if ... the file has been modified ...
    status = header:set(table.remove(path_table))
                 .. mod:set(AddSymbolIfSet('modified', '+')) .. status
    return status
end

--- uses fugitive to check if in a git directory, and if it is, return the head.
function GetBranch()
    if vim.fn.FugitiveIsGitDir() == 1 then
        return sl_item:set('⤤ ' .. vim.fn.FugitiveHead())
                   .. bracket:set(' ' .. symbols.ra) .. ' '
    end
    return ''
end

--- checks if a boolean option is true, then adds a user defined symbol if it is.
function AddSymbolIfSet(option, symbol_to_use)
    if (vim.api.nvim_get_option_value(option, {}) == true) then
        return symbol_to_use
    end
    return ''
end

--- finally, customize the statusline using the components we made.
--- function MakeStatusLine()
vim.g.MakeStatusLine = function()
    -- left hand side padding, also declaration for easier adjusting.
    local sl = header:set '  '

    -- left hand side.
    if LS.in_snippet() then
        sl = sl .. 'in snippet'
        if LS.expand_or_jumpable() then
            if LS.expandable() then
                sl = sl .. bracket:set ' ->' .. sl_item:set ' [expandable]'
                         .. directory:set ' <tab>'
            end
            if LS.jumpable() then
                sl = sl .. bracket:set ' ->' .. sl_item:set ' [jumpable]'
                         .. directory:set ' <tab>'
            end
        end
        if LS.choice_active() then
            local choices = LS.get_current_choices()
            for i, choice in ipairs(choices) do
                if choice == '' then
                    choices[i] = '[empty]'
                end
                choices[i] = sl_item:set(choices[i])
            end
            sl = sl .. bracket:set ' ->' .. sl_item:set ' choice node '
                     .. directory:set '<c-j>' .. bracket:set ' || '
                     .. directory:set '<c-k>' .. bracket:set ': '
                     .. table.concat(choices, directory:set ' | ')
        end
    else
        sl = sl .. MakePath()
    end

    -- where to truncate and where the statusline splits.
    sl = sl .. '%='

    -- right hand side
    sl = sl .. '        ' -- added 8 spaces of padding for when the status line is long.
    sl = sl .. '        ' -- added 8 spaces of padding for when the status line is long.
    sl = sl .. GetBranch()
    sl = sl .. sl_item:set 'buf %n' -- buffer id.
    sl = sl .. header:set '  ' -- rhs padding.

    -- updates the window being worked in only.
    vim.wo.statusline = sl
    return sl
end
-- end functions }}}

vim.o.statusline = '%{%g:MakeStatusLine()%}'

-- add autocommands for the statusline to update more frequently.
vim.api.nvim_create_autocmd(
    { 'VimEnter', 'WinEnter', 'BufWinEnter', 'WinNew', 'BufModifiedSet' },
        { callback = vim.g.MakeStatusLine }
)
vim.api.nvim_create_autocmd(
    { 'FileType' },
        { pattern = { 'nerdtree' }, callback = vim.g.MakeStatusLine }
)

-- vim: fdm=marker foldlevel=0
