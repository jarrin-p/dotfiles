require 'Global'

-- vim-plug initialization
local Plug = vim.fn['plug#']
if vim.fn.has('unix') == 1 then
	vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
elseif vim.fn.has('mac') == 1 then
	vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
end

-- import plugins
Plug 'psliwka/vim-smoothie'
Plug 'petertriho/nvim-scrollbar'
Plug 'tpope/vim-fugitive'
Exec "Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }"

Exec "Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}"
Plug "williamboman/nvim-lsp-installer"
Plug "neovim/nvim-lspconfig"

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim' -- depends on `plenary.vim`
Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'

-- Plug 'dense-analysis/ale'

-- end of plugin defining
vim.call('plug#end')

-- setup plugins
require("scrollbar").setup()

require("nvim-lsp-installer").setup {
  automatic_installation = true
}
local servers = { 'pyright', 'jdtls', 'sumneko_lua', 'terraformls' }
for _, server in pairs(servers) do
    if server == 'sumneko_lua' then
        require('lspconfig')[server].setup {
            settings = { Lua = { version = 'LuaJIT', diagnostics = { globals = { 'vim' } } } } }
    else
        require('lspconfig')[server].setup {}
    end
end

-- plugin settings
GSet.NERDTreeWinSize = 50
GSet.NERDTreeShowBookmarks = 1
