local M = {
    --- gets the absolute path of the currently worked on file using `expand`
    --- and splits it into a table.
    --- @return table abs_file_table an ordered table containing each directory for the path.
    get_absolute_path_as_table = function()
        local abs_file_path = {}
        for match in vim.fn.expand('%:p'):sub(1):gmatch('/[^/]*') do
            table.insert(abs_file_path, (match:gsub('/', '')))
        end
        return abs_file_path
    end,
}
return M
