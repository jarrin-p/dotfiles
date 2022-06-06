require 'Global'

-- vim-plug initialization
local Plug = Vim.fn['plug#']
if Vim.fn.has('unix') == 1 then
	Vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
elseif Vim.fn.has('mac') == 1 then
	Vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
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
Vim.call('plug#end')

-- setup plugins
require("scrollbar").setup()

require("nvim-lsp-installer").setup {
  automatic_installation = true
}
local servers = { 'pyright', 'jdtls', 'sumneko_lua', 'terraformls' }
for _, server in pairs(servers) do
    require('lspconfig')[server].setup {}
end

-- plugin settings
GSet.NERDTreeWinSize = 50
GSet.NERDTreeShowBookmarks = 1
