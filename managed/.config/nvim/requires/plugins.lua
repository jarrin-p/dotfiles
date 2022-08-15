--- @author jarrin-p
--- @file `plugins.lua`
local Plug = vim.fn['plug#']
if vim.fn.has('unix') == 1 then
    vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
elseif vim.fn.has('mac') == 1 then
    vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
end

-- import plugins
Exec 'Plug \'junegunn/fzf\', { \'do\': { -> fzf#install() } }'
Exec 'Plug \'nvim-treesitter/nvim-treesitter\', {\'do\': \':TSUpdate\'}'
Plug 'L3MOn4d3/LuaSnip' -- snippets plugin
Plug 'hrsh7th/cmp-nvim-lsp' -- lsp source for nvim-cmp
Plug 'hrsh7th/nvim-cmp' -- autocompletion plugin
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'preservim/nerdtree'
Plug 'saadparwaiz1/cmp_luasnip' -- snippets source for nvim-cmp
Plug 'sainnhe/vim-color-forest-night'
Plug 'scalameta/nvim-metals'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vimwiki/vimwiki'
Plug 'williamboman/nvim-lsp-installer'

vim.call('plug#end')

--- simple nvim specific setups
vim.cmd('colorscheme everforest')

-- vim: fdm=marker foldlevel=0
