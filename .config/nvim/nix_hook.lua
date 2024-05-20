--- using `setup.lua` instead of `init.lua` because init is on the lua search path already,
--- however it is desired for this to be called before nvim calls anything else.
require "os"

local home_dir = os.getenv("HOME")
os.execute("cd " .. home_dir .. "/.config && make build")

-- these must run before neovim loads anything else.
vim.cmd('let g:gruvbox_material_enable_italic = 1')
vim.cmd('colorscheme gruvbox-material')
require "utils"
