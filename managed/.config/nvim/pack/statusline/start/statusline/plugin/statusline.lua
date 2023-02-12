--- @author jarrin-p
--- @file `snippets.lua`
local util = require 'pack.statusline.util.util'
local path = require 'pack.statusline.util.path'
local cg = require 'pack.statusline.util.component'
--- TODO: nodes that connect forwards, backwards inspecting each other to create the transitions.

local fg = GetColorschemeAsHex('Fg', 'foreground')
local darker = GetColorschemeAsHex('FloatBorder', 'background')

local set_hl = vim.api.nvim_set_hl
-- local builder = require 'pack.statusline.start.statusline.util.builder'
set_hl(0, 'StatuslineSeparator', { fg = Colors.gui.comment_fg })
set_hl(0, 'StatuslineDirectory', { italic = 1, fg = Colors.gui.comment_fg, bg = darker })
set_hl(0, 'StatuslineHeader', { fg = 'Black', bg = fg })
set_hl(0, 'StatuslineHeaderReverse', { fg = fg, bg = 'Black' })
set_hl(0, 'StatuslineHeaderModified', { fg = 'Black', bg = fg })
-- set_hl(0, 'StatuslineNormal', { bg = Colors.gui.statusline_background_default })

-- define easier way to specify what values to set color groups in the status line.
local bracket = cg:new{ name = 'StatuslineSeparator' }
local directory = cg:new{ name = 'StatuslineDirectory' }
local header = cg:new{ name = 'StatuslineHeader' }
local mod = cg:new{ name = 'StatuslineHeaderModified' }

-- specific objects that get reused.
local transition_header_to_dir = header:get_transition_to(directory, 'background', Symbols.left_tr):get_value()
local dir_git = directory:set 'Git'
local dir_fug = directory:set 'Fugitive'

local buffer_types = { terminal = header:set 'Terminal  ' .. transition_header_to_dir }
local file_types = {
    minimap = header:set 'Minimap  ' .. transition_header_to_dir,
    help = header:set 'Help  ' .. transition_header_to_dir,
    qf = header:set 'Quick Fix || Location List  ' .. transition_header_to_dir,
    fugitive = header:set 'Fugitive  ' .. transition_header_to_dir .. dir_git,
    gitcommit = header:set 'Commit  ' .. transition_header_to_dir .. dir_fug .. dir_git,
    git = header:set 'Branch  ' .. transition_header_to_dir .. dir_fug .. dir_git,
}

--- build the path itself.
function MakePath()

    -- check to make buffer specific headers.
    local buf_type = vim.api.nvim_get_option_value('buftype', {})
    if buffer_types[buf_type] then
        return buffer_types[buf_type]
    end

    -- check to make filetype specific headers.
    local file_type = vim.api.nvim_get_option_value('filetype', {})
    if file_types[file_type] then
        return file_types[file_type]
    end

    return ConvertTableToPathString(path.getAbsoluteAsTable(), 5)
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

    local pathing, reverse_path = '', {}
    for i = #path_table, project_root_index, -1 do
        table.insert(reverse_path, path_table[i])
    end

    -- while there's more than one entry left to add to the path that will be displayed
    while (#reverse_path > 1) do

        -- pop the next item to be displayed in the path from the stack and add a bracket
        local pop = table.remove(reverse_path)
        if #reverse_path < truncate_point then
            pathing = Symbols.bl .. ' ' .. pop .. ' ' .. pathing

        elseif #path_table == truncate_point then
            -- set the point where truncation occurs on the list
            pathing = ' ' .. directory:set ' <% '
        end
    end
    pathing = directory:set(pathing)

    --- the `open` file itself is the last item in the table to be popped.
    --- additionally, adds a modified symbol if ... the file has been modified ...
    local modifiedStatus = mod:set(util.getIfSet('modified', '+'))
    pathing =
        header:set(table.remove(path_table)) .. modifiedStatus .. ' ' .. transition_header_to_dir .. bracket:set ''
            .. pathing

    return pathing
end

--- definition of the statusline as a vim global function in order to reference it
--- inside the statusline functino call natively.
vim.g.MakeStatusLine = function()
    -- left hand side padding, also declaration for easier adjusting.
    local sl = header:set '  '
    sl = sl .. MakePath() .. directory:set ' '

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
