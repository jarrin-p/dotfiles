Vim = vim -- keeps language server from freaking out

--- shorthand defaults to false when no bool passed
Exec = function (str, bool)
    bool = bool or false
    Vim.api.nvim_exec(str, bool)
end

--- more intuitive shorthand for setting, use `.` syntax on setting
Set = Vim.o
GSet = Vim.g
SetWinLocal = Vim.wo

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
