--- @author jarrin-p
--- @file `settings.lua`
vim.o.compatible = false

--- shada settings {{{
-- @see 'h sd' or 'h shada'
local shada_settings = {
    '!', -- restores global variables.
    -- '%5',  -- restore # buffers.
    '\'10', -- reduce number of history files.
    '<50',
    's10',
    'h', -- disable hlsearch when loading shada file.
}
vim.o.shada = table.concat(shada_settings, ',')
-- }}}

--- gui settings {{{
vim.g.font_size = 15
vim.g.FontKW = 'JetBrains Mono:h' .. vim.g.font_size .. ', Fira Code:h'
vim.o.guifont = vim.g.FontKW .. vim.g.font_size .. ''
vim.o.linespace = 12

--- sets the font size using a controlled global variable. allows easy remapping for increasing and decreasing
--- font size, something very much appreciated by others when screen sharing.
--- @param amt number the amount to change the font size by. must be an integer. can be negative or positive.
function SetFontSize(amt)
    if vim.g.font_size + amt > 0 then
        vim.g.font_size = vim.g.font_size + amt
        vim.o.guifont = vim.g.FontKW .. vim.g.font_size .. ''
    end
end
-- }}}

--- window settings {{{
vim.o.title = true
vim.o.titlestring = '%t'
vim.o.showtabline = 2 -- always show the tabline
vim.o.tabstop = 4
vim.o.shiftwidth = 0 -- 0 means use tabstop value.
vim.o.expandtab = true -- use spaces instead of tabs.
vim.o.smartindent = false -- trying out only autoindent.
vim.o.wrap = false
vim.o.number = true
vim.o.relativenumber = true -- show how many lines away instead of exact line number.
vim.o.syntax = 'on'
vim.o.foldcolumn = '3'
vim.o.foldmethod = 'manual'
vim.o.path = vim.o.path .. '**'
vim.o.signcolumn = 'yes'
vim.o.updatetime = 25
vim.o.foldlevelstart = 99
vim.o.scrolloff = 2 -- a little padding for the top and bottom of screen.
vim.o.cursorline = true
vim.o.textwidth = 0
vim.o.showmode = true -- specifically defining as true for whatever reason.
vim.o.splitright = true -- splits new window to the right.
vim.o.splitbelow = true -- splits new window down.
vim.o.list = true
vim.o.listchars = 'tab:-->,leadmultispace:│   ,trail:-'
vim.o.jumpoptions = 'view'
-- ·
vim.opt_global.shortmess:remove('F') -- used for `nvim metals`
vim.o.mouse = 'nv'
vim.o.termguicolors = true
--}}}

--- editing settings {{{
vim.o.backspace = 'indent,eol,start'
vim.o.magic = true
vim.o.spell = false
vim.o.inccommand = 'split'
vim.o.completeopt = 'menu,menuone,preview,noselect'
vim.o.ignorecase = false
vim.o.smartcase = true
vim.o.clipboard = 'unnamed,unnamedplus'
vim.o.autowrite = true
vim.o.hidden = false
-- }}}

--- builtin plugin settings {{{
vim.g.netrw_liststyle = 3
vim.g.csv_nomap_cr = 1
-- }}}

--- term settings {{{
vim.o.ttimeoutlen = 0
-- }}}

--- grep pattern setup {{{
local patterns = { '!*.class', '!*.jar', '!*.java.html', '!*.git*' }
local pattern_string
for _, pattern in ipairs(patterns) do
    if pattern_string then
        pattern_string = pattern_string .. ' --glob=\'' .. pattern .. '\''
    else
        pattern_string = ' --glob=\'' .. pattern .. '\''
    end
end
local rg_string = 'rg --line-number --with-filename'
vim.o.grepprg = rg_string .. pattern_string
-- }}}
-- vim: fdm=marker foldlevel=0
