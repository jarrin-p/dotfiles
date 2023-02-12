--- @author jarrin-p
--- @file `snippets.lua`
local util = require 'pack.statusline.util.util'
local path = require 'pack.statusline.util.path'
local cg = require 'pack.statusline.util.component'

local fg = GetColorschemeAsHex('Fg', 'foreground')
local darker = GetColorschemeAsHex('FloatBorder', 'background')

local set_hl = vim.api.nvim_set_hl
set_hl(0, 'StatuslineHeader', { fg = 'Black', bg = fg })
set_hl(0, 'StatuslineDirectory', { italic = 1, fg = Colors.gui.comment_fg, bg = darker })
set_hl(0, 'StatuslineSeparator', { fg = Colors.gui.comment_fg })

-- define easier way to specify what values to set color groups in the status line.
local bracket = cg:new{ name = 'StatuslineSeparator' }
local directory = cg:new{ name = 'StatuslineDirectory' }
local header = cg:new{ name = 'StatuslineHeader' }

-- specific objects that get reused.
local transition_header_to_dir = header:get_transition_to(directory, 'background', Symbols.left_tr):get_value()
local dir_git = directory:set ' Git'
local dir_fug = directory:set ' Fugitive'

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

    -- otherwise, return an expanded path.
    return ConvertTableToPathString(path.getAbsoluteAsTable(), 5)
end

--- takes the path and converts it to a string that will be set on the statusline.
--- @param path_table table to be converted to status.
--- @param max_depth? number on the status line.
function ConvertTableToPathString(path_table, max_depth)
    if not path_table or #path_table == 0 then
        return 'New File ' .. transition_header_to_dir
    end
    max_depth = max_depth or #path_table

    local header_pop = table.remove(path_table)
    local pathing = header:set '' .. header_pop .. util.getIfSet('modified', '+') .. ' '
    pathing = pathing .. transition_header_to_dir .. directory:set ''

    local index = 1
    while (index < max_depth and #path_table ~= 0) do
        -- pop the next item to be displayed in the path from the stack and add a bracket
        local pop = table.remove(path_table) or ''
        pathing = pathing .. Symbols.bl .. ' ' .. pop .. ' '
        index = index + 1
    end

    --- the open file itself is the last item in the table to be popped.
    --- additionally, adds a modified symbol if ... the file has been modified ...
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
