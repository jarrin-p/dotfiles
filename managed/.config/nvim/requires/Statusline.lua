require 'Global'
require 'AutoCmdClass'

-- status line modifications
local bl = '«'
local te = '->'
-- local br = '»'
-- local enter_sym = '⏎'
-- local te = '⋯'

--- nvim highlight group wrapper that allows easier inline status text formatting.
-- additionally, has defaults specified to keep the status line uniform
SLColorgroup = {
    name = 'Not set',
    scope = 0,
    options = {
        underline = 1, -- underline needs to be enabled for custom underline color.
        sp = Colors.h_split_underline -- default for the underline color.
    },

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
        Vim.api.nvim_set_hl(obj.scope, obj.name, obj.options)
        return obj
    end,

    --- returns the string to use the color group in the status line.
    -- @param text_to_color [optional] for code readability, to "pseudo" wrap the group of characters to be colored.
    set = function(self, text_to_color)
        text_to_color = text_to_color or ''
        return '%#' .. self.name .. '#' .. text_to_color
    end,
}

-- create custom color groups for the status line. assigning them to variables
-- allows use of a `set` helper function so a redundant helper doesn't need to be
-- manually declared.
local bracket = SLColorgroup:new{ name = 'SLBracket', options = { bold = 0, ctermfg = 8 } }
local sl_item = SLColorgroup:new{ name = 'SLItem', options = { ctermfg = 121 } }
local directory = SLColorgroup:new{ name = 'SLDir', options = { italic = 1, ctermfg = 3 } }
local header = SLColorgroup:new{ name = 'SLFileHeader', options = { italic = 0, ctermfg = 11 } }
local mod = SLColorgroup:new{ name = 'SLModified', options = { italic = 0, ctermfg = 9 } }

function GetFullPathAsTable()
    local abs_file_path = {}
    for match in Vim.fn.expand('%:p'):sub(1):gmatch('/[^/]*') do
        table.insert(abs_file_path, (match:gsub('/', '')))
    end
    return abs_file_path
end

function LinearSearch(table_to_search, item_to_find)
    for i, item in ipairs(table_to_search) do
        if item == item_to_find then return i end
    end
end

function MakePath()
    local file_type = Vim.api.nvim_get_option_value('filetype', {})
    if file_type == 'help' then
        return header:set'Help'

    elseif file_type == 'qf' then
        return header:set'Quick Fix || Location List'

    elseif file_type == 'fugitive' then
        return header:set'Fugitive ' .. bracket:set(bl) .. directory:set' Git'

    elseif file_type == 'gitcommit' then
        return header:set'Commit ' .. bracket:set(bl) .. directory:set' Fugitive ' .. bracket:set(bl) .. directory:set' Git'

    elseif file_type == 'git' then
        return header:set'Branch ' .. bracket:set(bl) .. directory:set' Fugitive ' .. bracket:set(bl) .. directory:set' Git'

    elseif file_type == 'nerdtree' then
        return header:set'↟NERDTree'

    elseif Vim.fn.FugitiveIsGitDir() == 1 then
        local abs_file_path = GetFullPathAsTable()

        local _, last_index = Vim.fn.FugitiveWorkTree():find('.*/')
        local index_of_dir = LinearSearch(abs_file_path, (Vim.fn.FugitiveWorkTree():sub(last_index):gsub('/', '')) )

        -- iterate backwards to build the path to git dir
        local git_root_rel_path = {}
        for i = #abs_file_path, index_of_dir, -1 do table.insert(git_root_rel_path, abs_file_path[i]) end

        -- while there's more than one entry left to add to the path that will be displayed
        local status = ''
        while (#git_root_rel_path > 1) do
            -- pop the next item to be displayed in the path from the stack and add a bracket
            status = directory:set(table.remove(git_root_rel_path)) .. status
            status =  ' ' .. bracket:set(bl) .. ' ' .. status

            -- set the point where truncation occurs on the list
            if #git_root_rel_path == 5 then status = ' ' .. bracket:set(bl) .. directory:set' ...%< ' .. status end
        end

        -- the `open` file itself is the last item in the table to be popped.
        status = header:set(table.remove(git_root_rel_path)) .. mod:set(AddSymbolIfSet('modified', '+')) .. status
        return status
    else
        -- while there's more than one entry left to add to the path that will be displayed
        local status, abs_file_path = '', GetFullPathAsTable()
        local reverse_path = {}
        for i = #abs_file_path, 1, -1 do table.insert(reverse_path, abs_file_path[i]) end
        while (#reverse_path > 1) do
            -- pop the next item to be displayed in the path from the stack and add a bracket
            status = directory:set(table.remove(reverse_path)) .. status
            status =  ' ' .. bracket:set(bl) .. ' ' .. status

            -- set the point where truncation occurs on the list
            if #abs_file_path == 5 then status = ' ' .. bracket:set(bl) .. directory:set' ...%< ' .. status end
        end

        -- the `open` file itself is the last item in the table to be popped.
        status = header:set(table.remove(abs_file_path)) .. mod:set(AddSymbolIfSet('modified', '+')) .. status

        return status
    end
end

--- uses fugitive to check if in a git directory, and if it is, return the head.
function GetBranch()
    if Vim.fn.FugitiveIsGitDir() == 1 then
        return sl_item:set("⤤ " .. Vim.fn.FugitiveHead()) .. bracket:set(" " .. te) .. ' '
    else
        return ''
    end
end

--- checks if a boolean option is true, then adds a user defined symbol if it is.
function AddSymbolIfSet(option, symbol_to_use)
    if (Vim.api.nvim_get_option_value(option, {}) == true) then
        return symbol_to_use
    else
        return ''
    end
end

function MakeStatusLine()
    -- lhs padding, also declaration for easier adjusting
    local sl = header:set'  '

    -- lhs
    sl = sl .. MakePath()

    -- where to truncate and where the statusline splits
    sl = sl .. "%="

    -- rhs
    sl = sl .. '        ' -- added 8 spaces of padding for when the status line is long
    sl = sl .. '        ' -- added 8 spaces of padding for when the status line is long
    sl = sl .. '        ' -- added 8 spaces of padding for when the status line is long
    sl = sl .. GetBranch()
    sl = sl .. sl_item:set"buf %n" -- buffer id
    sl = sl .. header:set'  ' -- rhs padding

    -- set based on the string
    SetWinLocal.statusline = sl
end

AutoCmd:new{event = 'WinEnter', cmd = 'lua MakeStatusLine()'}:add()
AutoCmd:new{event = 'BufWinEnter', cmd = 'lua MakeStatusLine()'}:add()
AutoCmd:new{event = 'VimEnter', cmd = 'lua MakeStatusLine()'}:add()
AutoCmd:new{event = 'WinNew', cmd = 'lua MakeStatusLine()'}:add()
AutoCmd:new{event = 'BufModifiedSet', cmd = 'lua MakeStatusLine()'}:add()
