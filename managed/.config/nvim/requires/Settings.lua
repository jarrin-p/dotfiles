require 'Global'

Set = vim.o     -- shorthand
Set.compatible = false

-- Terminal Settings
Set.title = true
Set.titlestring = '%t'

-- Buffer Settings
Set.hidden = false     -- seeing if this will reduce the number of buffers that open
Set.tabstop = 4        -- autocmd for java to be 2
Set.shiftwidth = 0     -- 0 means use tabstop value
Set.expandtab = true   -- use spaces instead of tabs
Set.smartindent = false -- trying out only autoindent
Set.wrap = false
Set.number = true
Set.relativenumber = true   -- show how many lines away instead of exact line number
Set.syntax = 'on'
Set.foldcolumn = '3'
Set.foldmethod = 'indent'
Set.path = Set.path .. '**'
Set.signcolumn = 'yes'
Set.updatetime = 100
Set.foldlevelstart = 99
Set.scrolloff = 2
Set.cursorline = true
Set.textwidth = 120
Set.showmode = true  -- changed to false because of lightline plugin
Set.splitright = true -- splits new window to the right
Set.splitbelow = true -- splits new window down
-- Set.switchbuf = '' -- new tabs for some commands
-- Set.sessionoptions = 'localoptions,folds,options,tabpages,winsizes,sesdir'

-- Editing Settings
Set.backspace = 'indent,eol,start'
Set.magic = true
Set.inccommand = 'nosplit'

-- plugin settings that come with vim
GSet.netrw_liststyle = 3
GSet.csv_nomap_cr = 1

-- sets the grep program as ripgrep
local patterns = {
    '!*.class',
    '!*.jar',
    '!*.java.html',
    '!*.git*'
}
local pattern_string
for _, pattern in ipairs(patterns) do
    if pattern_string then pattern_string = pattern_string .. " --glob='" .. pattern .. "'"
    else pattern_string = " --glob='" .. pattern .. "'" end
end
Set.grepprg = "rg --line-number --with-filename" .. pattern_string
