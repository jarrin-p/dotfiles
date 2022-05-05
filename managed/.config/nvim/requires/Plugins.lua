local vim = vim

-- vim-plug initialization
local Plug = vim.fn['plug#']
if vim.fn.has('unix') == 1 then
	vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
elseif vim.fn.has('mac') == 1 then
	vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
end

-- import plugins
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
--Plug 'itchyny/lightline.vim'
Plug 'psliwka/vim-smoothie'
vim.api.nvim_exec("Plug 'neoclide/coc.nvim', {'branch': 'release'}", false)
vim.api.nvim_exec("Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }", false)
vim.api.nvim_exec("Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}", false)

-- end of
vim.call('plug#end')

-- plugin settings
vim.g.NERDTreeWinSize = 50
vim.g.NERDTreeShowBookmarks = 1
