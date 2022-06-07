-- vim-plug initialization
local Plug = vim.fn['plug#']
if vim.fn.has('unix') == 1 then vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
elseif vim.fn.has('mac') == 1 then vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
end

-- import plugins
Plug 'psliwka/vim-smoothie'
Plug 'petertriho/nvim-scrollbar'
Plug 'tpope/vim-fugitive'
Exec "Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }"
Exec "Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}"
Plug 'williamboman/nvim-lsp-installer'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim' -- depends on `plenary.vim`
Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'

-- end of plugin defining
vim.call('plug#end')

-- setup plugins
require('scrollbar').setup()
require 'nvim-treesitter.configs'.setup {
	ensure_installed = 'all',             -- 'all', 'maintained', or a table of languages
	sync_install = true,                  -- install languages synchronously (only applied to `ensure_installed`)
	-- ignore_install = { 'javascript' }, -- list of parsers to ignore installing
	highlight = {
		enable = true,                    -- `false` will disable the whole extension
		--disable = { 'c', 'rust' },      -- list of languages that will be disabled
		additional_vim_regex_highlighting = true,
	},
}
require('nvim-lsp-installer').setup{ automatic_installation = true }
-- lsp server setups. defaults are fine for most.
local servers = {
    'pyright',
    'jdtls',
    'sumneko_lua',
    'terraformls',
    'bashls'
}
local r = require('lspconfig')
for _, s in pairs(servers) do
    if s == 'sumneko_lua' then
        r[s].setup { settings = { Lua = { version = 'LuaJIT', diagnostics = { globals = { 'vim' } } } } }
    elseif s == 'bashls' then
        r[s].setup { filetypes = { "sh", "bash", "zsh" } }
    else
        r[s].setup {}
    end
end

-- some additional plugin settings that need to be set through globals.
GSet.NERDTreeWinSize = 50
GSet.NERDTreeShowBookmarks = 1
