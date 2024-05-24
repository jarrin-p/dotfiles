--- using `setup.lua` instead of `init.lua` because init is on the lua search path already,
--- however it is desired for this to be called before nvim calls anything else.
require "os"

local xdg_dir = os.getenv("DOTX_CONFIG_LOCATION")
vim.g.dotx = xdg_dir

-- todo: os specific behavior.
os.execute("cd " .. xdg_dir .. " && make build > /tmp/dotx-buildlog")

local added_dirs = "," .. xdg_dir .. "/nvim" .. "," .. xdg_dir .. "/nvim/after"
vim.o.runtimepath = vim.o.runtimepath .. added_dirs
vim.o.packpath = vim.o.packpath .. added_dirs

-- these must run before neovim loads anything else.
vim.cmd('let g:gruvbox_material_enable_italic = 1')
vim.cmd('colorscheme gruvbox-material')

require "utils"
