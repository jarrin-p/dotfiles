--- @author jarrin-p
--- @file `snippets.lua`
LS = require 'luasnip'
--- TODO: nodes that connect forwards, backwards inspecting each other to create the transitions.

--- create custom color groups for the status line. assigning them to variables
--- allows the color groups to have a `set` helper function that uses defaults.
local bracket = InlineColorGroup:new{ name = 'SLBracket', options = { fg = Colors.gui.comment_fg } }
local sl_item = InlineColorGroup:new{ name = 'SLItem', options = { fg = Colors.gui.boolean_fg } }
local directory = InlineColorGroup:new{
    name = 'SLDir',
    options = { italic = 1, ctermfg = 3, fg = Colors.gui.comment_fg },
    posttext = ' ' .. Symbols.bl,
}
local header = InlineColorGroup:new{
    name = 'SLFileHeader',
    options = { bold = 0, italic = 0, ctermfg = 11, bg = Colors.gui.boolean_fg, fg = Colors.gui.cursor_fg },
}
local header_reverse = InlineColorGroup:new{
    name = 'SLFileHeaderReverse',
    options = { bold = 0, italic = 0, ctermfg = 11, fg = Colors.gui.boolean_fg, bg = Colors.gui.normal_bg },
}
local mod = InlineColorGroup:new{
    name = 'SLModified',
    options = { bold = 1, ctermfg = 9, fg = Colors.gui.identifier_fg, bg = Colors.gui.boolean_fg },
}
local sl_norm = InlineColorGroup:new{ name = 'SLNorm', options = { bg = Colors.gui.normal_bg } }

--- functions {{{
--- gets the absolute path of the currently worked on file using `expand`
--- and splits it into a table.
--- @return table abs_file_table an ordered table containing each directory for the path.
function GetAbsolutePathAsTable()
    local abs_file_path = {}
    for match in vim.fn.expand('%:p'):sub(1):gmatch('/[^/]*') do table.insert(abs_file_path, (match:gsub('/', ''))) end
    return abs_file_path
end

--- standard linear search function.
--- @param table_to_search table the table to be searched.
--- @param item_to_find any item to be found in the table.
--- @return number index of item. returns `-1` if nothing is found.
function LinearSearch(table_to_search, item_to_find)
    for i, item in ipairs(table_to_search) do if item == item_to_find then return i end end
    return -1
end

--- build the path itself.
function MakePath()
    local file_type = vim.api.nvim_get_option_value('filetype', {})
    local buf_type = vim.api.nvim_get_option_value('buftype', {})

    if buf_type == 'terminal' then
        return header:set 'Terminal  ' .. header_reverse:set(Symbols.left_tr)

    elseif file_type == 'minimap' then
        return header:set 'Minimap  ' .. header_reverse:set(Symbols.left_tr)

    elseif file_type == 'help' then
        return header:set 'Help  ' .. header_reverse:set(Symbols.left_tr)

    elseif file_type == 'qf' then
        return header:set 'Quick Fix || Location List  ' .. header_reverse:set(Symbols.left_tr)

    elseif file_type == 'fugitive' then
        return header:set 'Fugitive  ' .. header_reverse:set(Symbols.left_tr) .. directory:set ' Git'

    elseif file_type == 'gitcommit' then
        return header:set 'Commit  ' .. header_reverse:set(Symbols.left_tr) .. directory:set ' Fugitive '
                   .. directory:set ' Git'

    elseif file_type == 'git' then
        return header:set 'Branch  ' .. header_reverse:set(Symbols.left_tr) .. directory:set ' Fugitive '
                   .. directory:set ' Git'

    elseif vim.fn.FugitiveIsGitDir() == 1 then
        local abs_file_path = GetAbsolutePathAsTable()

        local _, last_index = vim.fn.FugitiveWorkTree():find('.*/')
        local index_of_dir = LinearSearch(abs_file_path, (vim.fn.FugitiveWorkTree():sub(last_index):gsub('/', '')))

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
function ConvertTableToPathString(path_table, truncate_point, project_root_index)
    if not path_table then return 'no path to convert' end
    truncate_point = truncate_point or #path_table
    project_root_index = project_root_index or 1

    local status, reverse_path = '', {}
    for i = #path_table, project_root_index, -1 do table.insert(reverse_path, path_table[i]) end

    -- while there's more than one entry left to add to the path that will be displayed
    while (#reverse_path > 1) do

        -- pop the next item to be displayed in the path from the stack and add a bracket
        local pop = directory:set(table.remove(reverse_path))
        if #reverse_path < truncate_point then
            status = ' ' .. pop .. status

        elseif #path_table == truncate_point then
            -- set the point where truncation occurs on the list
            status = ' ' .. directory:set ' <% '
        end
    end

    --- the `open` file itself is the last item in the table to be popped.
    --- additionally, adds a modified symbol if ... the file has been modified ...
    status = header:set(table.remove(path_table)) .. mod:set(AddSymbolIfSet('modified', '+')) .. header:set ' '
                 .. header_reverse:set(Symbols.left_tr) .. bracket:set '' .. status
    return status
end

--- checks if a boolean option is true, then adds a user defined symbol if it is.
function AddSymbolIfSet(option, symbol_to_use)
    if (vim.api.nvim_get_option_value(option, {}) == true) then return symbol_to_use end
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
                sl = sl .. bracket:set ' ->' .. sl_item:set ' [expandable]' .. directory:set ' <tab>'
            end
            if LS.jumpable() then
                sl = sl .. bracket:set ' ->' .. sl_item:set ' [jumpable]' .. directory:set ' <tab>'
            end
        end
        if LS.choice_active() then
            local choices = LS.get_current_choices()
            for i, choice in ipairs(choices) do
                if choice == '' then choices[i] = '[empty]' end
                choices[i] = sl_item:set(choices[i])
            end
            sl = sl .. bracket:set ' ->' .. sl_item:set ' choice node ' .. directory:set '<c-j>' .. bracket:set ' || '
                     .. directory:set '<c-k>' .. bracket:set ': ' .. table.concat(choices, directory:set ' | ')
        end
    else
        sl = sl .. MakePath()
    end

    sl = sl .. sl_norm:set ''
    -- updates the window being worked in only.
    vim.wo.statusline = sl
    return sl
end
-- end functions }}}

vim.o.statusline = '%{%g:MakeStatusLine()%}'

-- add autocommands for the statusline to update more frequently.
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter', 'WinNew', 'BufModifiedSet' },
    { callback = vim.g.MakeStatusLine })
vim.api.nvim_create_autocmd({ 'FileType' }, { pattern = { 'nerdtree' }, callback = vim.g.MakeStatusLine })

-- vim: fdm=marker foldlevel=0
