--- @author jarrin-p
--- @file `snippets.lua`
local util = require 'pack.statusline.start.statusline.util.util'
local path = require 'pack.statusline.start.statusline.util.path'
local cg = require 'pack.statusline.start.statusline.util.component'
--- TODO: nodes that connect forwards, backwards inspecting each other to create the transitions.

local set_hl = vim.api.nvim_set_hl
-- local builder = require 'pack.statusline.start.statusline.util.builder'
set_hl(0, 'StatuslineSeparator', { fg = Colors.gui.comment_fg })
set_hl(0, 'StatuslineDirectory',
    { italic = 1, fg = Colors.gui.comment_fg, bg = Colors.gui.statusline_background_default })
set_hl(0, 'StatuslineHeader', { bg = 'Black', fg = Colors.gui.cursor_fg })
set_hl(0, 'StatuslineHeaderReverse', { fg = 'Black', bg = Colors.gui.cursor_fg })
set_hl(0, 'StatuslineModified', { fg = Colors.gui.identifier_fg, bg = 'Black' })
set_hl(0, 'StatuslineNormal', { bg = Colors.gui.statusline_background_default })

-- define easier way to specify what values to set color groups in the status line.
local bracket = cg:new{ name = 'StatuslineSeparator' }
local directory = cg:new{ name = 'StatuslineDirectory', pretext = ' ', posttext = ' ' .. Symbols.bl }
local header = cg:new{ name = 'StatuslineHeader' }
local header_reverse = cg:new{ name = 'StatuslineHeaderReverse' }
local mod = cg:new{ name = 'StatusLineModified' }

-- specific objects that get reused.
local header_la = header_reverse:set(Symbols.left_tr)
local dir_git = directory:set 'Git'
local dir_fug = directory:set 'Fugitive'

--- build the path itself.
function MakePath()
    local file_type = vim.api.nvim_get_option_value('filetype', {})
    local buf_type = vim.api.nvim_get_option_value('buftype', {})

    if buf_type == 'terminal' then
        return header:set 'Terminal  ' .. header_la

    elseif file_type == 'minimap' then
        return header:set 'Minimap  ' .. header_la

    elseif file_type == 'help' then
        return header:set 'Help  ' .. header_la

    elseif file_type == 'qf' then
        return header:set 'Quick Fix || Location List  ' .. header_la

    elseif file_type == 'fugitive' then
        return header:set 'Fugitive  ' .. header_la .. dir_git

    elseif file_type == 'gitcommit' then
        return header:set 'Commit  ' .. header_la .. dir_fug .. dir_git

    elseif file_type == 'git' then
        return header:set 'Branch  ' .. header_la .. dir_fug .. dir_git

    elseif vim.fn.FugitiveIsGitDir() == 1 then
        local abs_file_path = path.getAbsoluteAsTable()

        local _, last_index = vim.fn.FugitiveWorkTree():find('.*/')
        local index_of_dir = util.linearSearch(abs_file_path, (vim.fn.FugitiveWorkTree():sub(last_index):gsub('/', '')))

        local status = ConvertTableToPathString(abs_file_path, 5, index_of_dir)
        return status
    else
        local status = ConvertTableToPathString(path.getAbsoluteAsTable(), 5)
        return status
    end
end

--- takes the path and converts it to a string that will be set on the statusline.
--- @param path_table table to be converted to status.
--- @param truncate_point? number on the status line.
--- @param project_root_index? number directory of the project root
function ConvertTableToPathString(path_table, truncate_point, project_root_index)
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
            status = '' .. pop .. status

        elseif #path_table == truncate_point then
            -- set the point where truncation occurs on the list
            status = ' ' .. directory:set ' <% '
        end
    end

    --- the `open` file itself is the last item in the table to be popped.
    --- additionally, adds a modified symbol if ... the file has been modified ...
    local modifiedStatus = mod:set(util.getIfSet('modified', '+'))
    status = header:set(table.remove(path_table)) .. modifiedStatus .. header:set ' '
                 .. header_reverse:set(Symbols.left_tr) .. bracket:set '' .. status

    return status
end

--- definition of the statusline as a vim global function in order to reference it
--- inside the statusline functino call natively.
vim.g.MakeStatusLine = function()
    -- left hand side padding, also declaration for easier adjusting.
    local sl = header:set '  '
    sl = sl .. MakePath()

    -- updates the window being worked in only.
    vim.wo.statusline = sl
    return sl
end

vim.o.statusline = '%{%g:MakeStatusLine()%}'

-- add autocommands for the statusline to update more frequently.
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter', 'WinNew', 'BufModifiedSet' },
    { callback = vim.g.MakeStatusLine })
vim.api.nvim_create_autocmd({ 'FileType' }, { pattern = { 'nerdtree' }, callback = vim.g.MakeStatusLine })

-- vim: fdm=marker foldlevel=0
