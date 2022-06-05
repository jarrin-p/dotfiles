require 'Global'

-- vim-plug initialization
local Plug = Vim.fn['plug#']
if Vim.fn.has('unix') == 1 then
	Vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
elseif Vim.fn.has('mac') == 1 then
	Vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
end

-- import plugins
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'psliwka/vim-smoothie'
Plug 'petertriho/nvim-scrollbar'
Plug 'tpope/vim-surround'
-- Exec "Plug 'neoclide/coc.nvim', {'branch': 'release'}"
Exec "Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }"
Exec "Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}"

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim' -- depends on `plenary.vim`
Plug 'dense-analysis/ale'

-- end of plugins
Vim.call('plug#end')

require("scrollbar").setup()

-- plugin settings
GSet.NERDTreeWinSize = 50
GSet.NERDTreeShowBookmarks = 1

-- ale
GSet.ale_java_eclipselsp_path = '/Users/japeters/Dev/etc/jdtls'
GSet.ale_java_eclipselsp_javaagent = '/Users/japeters/.gradle/caches/modules-2/files-2.1/org.projectlombok/lombok/1.18.24/13a394eed5c4f9efb2a6d956e2086f1d81e857d9/lombok-1.18.24.jar'
-- gotta come back to this
Exec [[let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'java': ['google_java_format', 'uncrustify'],
\} ]]
-- Exec [[let g:ale_linters = {'java': ['eclipselsp']}]]
Exec [[let g:ale_floating_preview = 1]]

