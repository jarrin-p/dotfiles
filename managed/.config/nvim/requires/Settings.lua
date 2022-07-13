--- @author jarrin-p
--- @file `Settings.lua`

require 'Util'
vim.o.compatible = false

--- shada settings {{{
-- @see 'h sd' or 'h shada'
local shada_settings = {
    '!',   -- restores global variables.
    -- '%5',  -- restore # buffers.
    "'10", -- reduce number of history files.
    '<50',
    's10',
    'h',   -- disable hlsearch when loading shada file.
}
vim.o.shada = table.concat(shada_settings, ',')
-- }}}

--- gui settings {{{
vim.o.guifont = 'Fira Code, Menlo Italic'
vim.o.linespace = 12
-- end gui settings }}}

--- window settings {{{
vim.o.title = true
vim.o.titlestring = '%t'
vim.o.showtabline = 2       -- always show the tabline
vim.o.hidden = false        -- seeing if this will reduce the number of buffers that open.
vim.o.tabstop = 4
vim.o.shiftwidth = 0        -- 0 means use tabstop value.
vim.o.expandtab = true      -- use spaces instead of tabs.
vim.o.smartindent = false   -- trying out only autoindent.
vim.o.wrap = false
vim.o.number = true
vim.o.relativenumber = true -- show how many lines away instead of exact line number.
vim.o.syntax = 'on'
vim.o.foldcolumn = '3'
vim.o.foldmethod = 'manual'
vim.o.path = vim.o.path .. '**'
vim.o.signcolumn = 'yes'
vim.o.updatetime = 50
vim.o.foldlevelstart = 99
vim.o.scrolloff = 2         -- a little padding for the top and bottom of screen.
vim.o.cursorline = true
vim.o.textwidth = 0
vim.o.showmode = true       -- specifically defining as true for whatever reason.
vim.o.splitright = true     -- splits new window to the right.
vim.o.splitbelow = true     -- splits new window down.
vim.o.list = true
vim.o.listchars = 'tab:-->,lead:·,trail:-'
-- end window settings }}}

--- editing settings {{{
vim.o.backspace = 'indent,eol,start'
vim.o.magic = true
vim.o.inccommand = 'split'
vim.o.completeopt = 'menu,menuone,preview,noselect'
vim.o.ignorecase = false
vim.o.smartcase = false -- interferes too much to searches.
vim.o.clipboard = 'unnamed,unnamedplus'
-- end editing settings }}}

--- builtin plugin settings {{{
vim.g.netrw_liststyle = 3
vim.g.csv_nomap_cr = 1
-- end builtin plugin settings }}}

--- grep pattern setup {{{
--- use plugins util.
local patterns = { '!*.class', '!*.jar', '!*.java.html', '!*.git*' }
local pattern_string
for _, pattern in ipairs(patterns) do
    if pattern_string then pattern_string = pattern_string .. " --glob='" .. pattern .. "'"
    else pattern_string = " --glob='" .. pattern .. "'" end
end
local rg_string = "rg --line-number --with-filename"
vim.o.grepprg = rg_string .. pattern_string
-- end grep pattern setup }}}

-- vim: fdm=marker foldlevel=0
