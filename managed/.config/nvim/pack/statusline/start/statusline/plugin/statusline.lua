--- @author jarrin-p
--- @file `snippets.lua`
local util = require 'pack.statusline.util.util'
local path = require 'pack.statusline.util.path'
local conf = require 'pack.statusline.util.config'

M = {}

--- takes the path and converts it to a string that will be set on the statusline.
--- @param path_table table to be converted to status.
--- @param max_depth? number how many parent directories to display of the file.
M.format_path_table_for_display = function(path_table, max_depth)
    if not path_table or #path_table == 0 then
        return 'New File ' .. conf.transitions.header_to_dir
    end
    max_depth = max_depth or #path_table

    local header_pop = table.remove(path_table)
    local pathing = conf.header:set '' .. header_pop .. util.getIfSet('modified', '+') .. ' '
    pathing = pathing .. conf.transitions.header_to_dir .. conf.directory:set ''

    local index = 1
    while (index < max_depth and #path_table ~= 0) do
        local pop = table.remove(path_table) or ''
        pathing = pathing .. Symbols.bl .. ' ' .. pop .. ' '
        index = index + 1
    end
    return pathing
end

M.make_path = function()
    -- check to make buffer specific headers.
    local buf_type = vim.api.nvim_get_option_value('buftype', {})
    if conf.buffer_types[buf_type] then
        return conf.buffer_types[buf_type]
    end

    -- check to make filetype specific headers.
    local file_type = vim.api.nvim_get_option_value('filetype', {})
    if conf.file_types[file_type] then
        return conf.file_types[file_type]
    end

    -- otherwise, return an expanded path.
    return M.format_path_table_for_display(path.get_absolute_path_as_table(), 5)

end

M.make_statusline = function()
    local sl = conf.header:set '  '
    sl = sl .. M.make_path() .. conf.directory:set ' '

    -- updates the window being worked in only.
    vim.wo.statusline = sl
    return sl
end

--- definition of the statusline as a vim global function in order to reference it
--- inside the statusline functino call natively.
vim.g.MakeStatusLine = M.make_statusline
vim.o.statusline = '%{%g:MakeStatusLine()%}'

-- add autocommands for the statusline to update more frequently.
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter', 'WinNew', 'BufModifiedSet' },
    { callback = vim.g.MakeStatusLine })

-- vim: fdm=marker foldlevel=0
