require 'Global'

-- vim-plug initialization
local Plug = Vim.fn['plug#']
if Vim.fn.has('unix') == 1 then
	Vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
elseif Vim.fn.has('mac') == 1 then
	Vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
end

-- import plugins
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
--Plug 'itchyny/lightline.vim'
Plug 'psliwka/vim-smoothie'
Plug 'petertriho/nvim-scrollbar'
Plug 'tpope/vim-surround'
--Plug 'jlanzarotta/bufexplorer'
Exec "Plug 'neoclide/coc.nvim', {'branch': 'release'}"
Exec "Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }"
Exec "Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}"

-- end of plugins
Vim.call('plug#end')

require("scrollbar").setup()

-- plugin settings
GSet.NERDTreeWinSize = 50
GSet.NERDTreeShowBookmarks = 1
