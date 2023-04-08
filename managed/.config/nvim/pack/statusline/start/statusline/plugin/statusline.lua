--- @author jarrin-p
--- @file `snippets.lua`
local util = require 'pack.statusline.util.util'
local symbols = util.symbols
local path = require 'pack.statusline.util.path'
local conf = require 'pack.statusline.util.config'

M = {}

--- takes the path and converts it to a string that will be set on the statusline.
--- @param path_table table to be converted to status.
--- @param max_depth? number how many parent directories to display of the file.
M.format_path_table_for_display = function(path_table, max_depth)
    if not path_table or #path_table == 0 then
        return conf.header:set '  New File ' .. conf.transitions.header_to_dir
    end
    max_depth = max_depth or #path_table

    local header_pop = table.remove(path_table)
    local pathing = conf.header:set '  ' .. header_pop .. util.getIfSet('modified', '+') .. ' '
    pathing = pathing .. conf.transitions.header_to_dir .. conf.directory:set ''

    local index = 1
    while (index < max_depth and #path_table ~= 0) do
        local pop = table.remove(path_table) or ''
        pathing = pathing .. symbols.bl .. ' ' .. pop .. ' '
        index = index + 1
    end
    return pathing
end

--- @return string #descriptor formatted for left hand side.
M.make_buffer_descriptor = function()
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

--- @return string #formatting for filling space.
--- todo: add transition here. possibly have this as function that takes two arguments,
--- that returns a supplier of string for the transitions between previous, next.
M.fill = function()
    return conf.fill:set ''
end

--- @return string #the statusline code for splitting into right align.
M.right_align = function()
    return '%='
end

--- @return string #the string representing file info.
M.make_file_info = function()
    local file_type = vim.api.nvim_get_option_value('filetype', {})
    if file_type == '' then
        file_type = 'Empty'
    end

    local val = conf.transitions.fill_to_ft_info .. conf.ft_info:set ' ' .. file_type .. ' ' .. symbols.br
                    .. '  %l:%L ' .. symbols.br .. ' col %c ' .. symbols.br .. ' buf %n '
    return val
end

--- all builder functions should be a function with no arguments returning a string (string supplier).
M.builder_functions = {}

M.add_builder_function = function(fn)
    table.insert(M.builder_functions, fn)
end

M.add_builder_function(M.make_buffer_descriptor)
M.add_builder_function(M.fill)
M.add_builder_function(M.right_align)
M.add_builder_function(M.make_file_info)

M.make_statusline = function()
    local sl = ''
    for _, builder_fn in ipairs(M.builder_functions) do
        sl = sl .. builder_fn()
    end

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
