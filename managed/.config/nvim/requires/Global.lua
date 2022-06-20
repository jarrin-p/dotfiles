--- shorthand defaults to false when no bool passed
Exec = function (str, bool)
    bool = bool or false
    vim.api.nvim_exec(str, bool)
end

--- more intuitive shorthand for setting, use `.` syntax on setting
Set = vim.o
GSet = vim.g
SetWinLocal = vim.wo

-- TODO look into `set termguicolors=...`
-- specifying colors manually. makes tweaking easier
-- these are basically manually defined to line up with current color scheme config
Colors = {
      cyan = 81,
      dark_blue = 8,
      red = 9,
      none = 'none',
      cursorline = '#f0aa8a', -- dark wood
      -- cursorline = '#a9dd9d', -- bright green
      -- cursorline = '#fd8489', -- red
      -- cursorline = '#ffebc3', -- foreground, light wood
      h_split_underline = '#7f8f9f',
}

--- recursively prints a table that has nested tables in a manner that isn't awful
-- @param element the array or table to be printed
-- @param indent (optional) spaces that will be added in each level of recursion
function RecursivePrint(element, indent)
    indent = indent or ''
    if type(element) == 'table' then
        for key, val in pairs(element) do
            if type(val) == 'table' then
                print(indent .. key .. ':')
                RecursivePrint(val, indent .. '  ')
            else
                key = (type(key) == 'boolean' and (key and 'true' or 'false') or key)
                print(indent .. key .. ': ' .. (type(val) == 'boolean' and (val and 'true' or 'false') or val))
            end
        end
    end
end

