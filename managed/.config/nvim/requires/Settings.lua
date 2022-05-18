local vim = vim -- keeps language server from freaking out
local exec = function (str) vim.api.nvim_exec(str, false) end

Set = vim.o     -- shorthand
Set.compatible = false

-- Terminal Settings
Set.title = true
Set.titlestring = '%t'

-- Buffer Settings
Set.hidden = true
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
Set.showmode = true  -- changed to false because of lightline plugin
Set.splitright = true -- splits new window to the right
Set.splitbelow = true -- splits new window down
Set.switchbuf = 'newtab' -- new tabs for some commands
--Set.sessionoptions = 'localoptions,folds,options,tabpages,winsizes,sesdir'

-- some custom color groups for the status line
local underline_color = " guisp=#7f8f9f" -- used for creating a "pseudo" split line
exec('hi SLContainer cterm=bold,underline' .. underline_color)
exec('hi SLFileHeader cterm=underline ctermfg=7' .. underline_color)
exec('hi SLSep cterm=underline ctermfg=8' .. underline_color)
exec('hi SLFilePath cterm=italic,underline ctermfg=0' .. underline_color)

-- functions for easily changing colors in statusline
local function c(container) return ('%#SlContainer#' .. container) end
local function h(header) return ('%#SLFileHeader#' .. header) end
local function s(separator) return ('%#SLSep#' .. separator) end
local function p(file_path) return ('%#SLFilePath#' .. file_path) end

local sl = "%-(" -- left justified item group
sl = sl .. c"[ "
sl = sl .. h"%{expand('%:t:r')}"
sl = sl .. h".%{expand('%:t:e')}" -- file name, file extension
sl = sl .. "%M%R%H%W" -- modifiers and other info
sl = sl .. c" ]"
sl = sl .. c"[ " .. h"buf %n" .. c" ]" -- buffer id
sl = sl .. "%)"
sl = sl .. "%<"

-- work in progress status line
function BuildExpanded() return vim.fn.expand("%:p"):gsub("/", " > ") end
-- sl = sl .. h"" .. BuildExpanded()

sl = sl .. "%=" -- group separator
sl = sl .. p"%{expand('%:p:h')} "
Set.statusline = sl

-- sets the grep program as ripgrep
Set.grepprg = "rg --line-number --with-filename --glob='!*.class' --glob='!*.jar' --glob='!*.java.html'"
-- currently defined default fzf command
-- rg --glob "!*.git" --glob "!*.class" --glob "!*.jar" --hidden --no-ignore --files

-- Editing Settings
Set.backspace = 'indent,eol,start'
Set.magic = true
Set.inccommand = 'nosplit'

-- plugin settings that come with vim
vim.g.netrw_liststyle = 3
vim.g.csv_nomap_cr = 1
