--- @author jarrin-p
--- @file `Settings.lua`

require 'Util'
Set.compatible = false

--- gui settings {{{
Set.guifont = 'Fira Code'
Set.linespace = 12
-- end gui settings }}}

--- window settings {{{
Set.title = true
Set.titlestring = '%t'
Set.hidden = false        -- seeing if this will reduce the number of buffers that open.
Set.tabstop = 4
Set.shiftwidth = 0        -- 0 means use tabstop value.
Set.expandtab = true      -- use spaces instead of tabs.
Set.smartindent = false   -- trying out only autoindent.
Set.wrap = false
Set.number = true
Set.relativenumber = true -- show how many lines away instead of exact line number.
Set.syntax = 'on'
Set.foldcolumn = '3'
Set.foldmethod = 'indent'
Set.path = Set.path .. '**'
Set.signcolumn = 'yes'
Set.updatetime = 100
Set.foldlevelstart = 99
Set.scrolloff = 2         -- a little padding for the top and bottom of screen.
Set.cursorline = true
Set.textwidth = 120       -- limit the width before it starts wrapping.
Set.showmode = true       -- specifically defining as true for whatever reason.
Set.splitright = true     -- splits new window to the right.
Set.splitbelow = true     -- splits new window down.
Set.list = true
Set.listchars = 'tab:-->,lead:·,trail:-'
-- end window settings }}}

--- quicktext function {{{
function QuickFixTextFunc()
    local quickfixtextfunc = {}
    for _, val in pairs(vim.fn.getqflist()) do
        table.insert(quickfixtextfunc, val.text )
    end
    GSet.ttt = quickfixtextfunc
end
Exec [[function! QFTextFunc(info)
    lua QuickFixTextFunc()
    return g:ttt
endfunc]]
Set.quickfixtextfunc = 'QFTextFunc'
-- end quicktext function }}}

--- editing settings {{{
Set.backspace = 'indent,eol,start'
Set.magic = true
Set.inccommand = 'split'
Set.completeopt = 'menu,menuone,preview,noselect'
Set.ignorecase = true
Set.smartcase = true
-- end editing settings }}}

--- builtin plugin settings {{{
GSet.netrw_liststyle = 3
GSet.csv_nomap_cr = 1
-- end builtin plugin settings }}}

--- grep pattern setup {{{
local patterns = { '!*.class', '!*.jar', '!*.java.html', '!*.git*' }
local pattern_string
for _, pattern in ipairs(patterns) do
    if pattern_string then pattern_string = pattern_string .. " --glob='" .. pattern .. "'"
    else pattern_string = " --glob='" .. pattern .. "'" end
end
local rg_string = "rg --line-number --with-filename"
Set.grepprg = rg_string .. pattern_string
-- end grep pattern setup }}}

-- vim: fdm=marker foldlevel=0
