local vim = vim

-- vim-plug initialization
local Plug = vim.fn['plug#']
if vim.fn.has('unix') == 1 then
	vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
elseif vim.fn.has('mac') == 1 then
	vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
end

-- Import plugins
Plug('morhetz/gruvbox')
Plug('sheerun/vim-polyglot')
vim.api.nvim_exec("Plug 'neoclide/coc.nvim', {'branch': 'release'}", false)
vim.api.nvim_exec("Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }", false)

-- End of
vim.call('plug#end')
