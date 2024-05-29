--- using `setup.lua` instead of `init.lua` because init is on the lua search path already,
--- however it is desired for this to be called before nvim calls anything else.
require "os"

local dotx_dir = os.getenv("DOTX_CONFIG_LOCATION") .. "/.config"
vim.g.dotx = dotx_dir

-- todo: os specific behavior.
os.execute("cd " .. dotx_dir .. " && make build > /tmp/dotx-buildlog")

local added_dirs = "," .. dotx_dir .. "/nvim" .. "," .. dotx_dir .. "/nvim/after"
vim.o.runtimepath = vim.o.runtimepath .. added_dirs
vim.o.packpath = vim.o.packpath .. added_dirs

-- these must run before neovim loads anything else.
vim.cmd('let g:gruvbox_material_enable_italic = 1')
vim.cmd('colorscheme gruvbox-material')

require "utils"
