--- using `setup.lua` instead of `init.lua` because init is on the lua search path already,
--- however it is desired for this to be called before nvim calls anything else.
require "os"

local xdg_dir = os.getenv("XDG_CONFIG_DIRS")
os.execute("cd " .. xdg_dir .. "/.config && make build")

-- these must run before neovim loads anything else.
vim.cmd('let g:gruvbox_material_enable_italic = 1')
vim.cmd('colorscheme gruvbox-material')

require "utils"
