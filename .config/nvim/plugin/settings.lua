vim.o.compatible = false
do
  local shada_settings = {["10"] = "<50", s10 = "h"}
  vim.o.shada = table.concat(shada_settings, ",")
end
vim.g.font_size = 15
vim.g.FontKW = ("JetBrains Mono:h" .. vim.g.font_size .. ", Fira Code:h")
vim.o.guifont = (vim.g.FontKW .. vim.g.font_size .. "")
vim.o.linespace = 12
local function _1_(amt)
  local delta = (vim.g.font_size + amt)
  if (delta > 0) then
    vim.g.font_size = delta
    return nil
  else
    vim.o.guifont = (vim.g.FontKW .. vim.g.font_size .. "")
    return nil
  end
end
SetFontSize = _1_
vim.o.title = true
vim.o.titlestring = "%t"
vim.o.showtabline = 2
vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.o.expandtab = true
vim.o.smartindent = false
vim.o.wrap = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.syntax = "on"
vim.o.foldcolumn = "3"
vim.o.foldmethod = "manual"
vim.o.path = (vim.o.path .. "**")
vim.o.signcolumn = "yes"
vim.o.updatetime = 25
vim.o.foldlevelstart = 99
vim.o.scrolloff = 2
vim.o.cursorline = true
vim.o.textwidth = 0
vim.o.showmode = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.o.listchars = "tab:;>,leadmultispace:    ,trail:-"
vim.o.jumpoptions = "view"
do end (vim.opt_global.shortmess):remove("F")
vim.o.mouse = "nv"
vim.o.termguicolors = true
vim.o.viewoptions = "folds,cursor"
vim.o.backspace = "indent,eol,start"
vim.o.magic = true
vim.o.spell = false
vim.o.inccommand = "split"
vim.o.completeopt = "menu,menuone,preview,noselect"
vim.o.ignorecase = false
vim.o.smartcase = true
vim.o.clipboard = "unnamed,unnamedplus"
vim.o.autowrite = true
vim.o.hidden = false
vim.g.netrw_liststyle = 3
vim.g.csv_nomap_cr = 1
vim.o.ttimeoutlen = 0
local patterns = {["!*.class"] = "!*.jar", ["!*.java.html"] = "!*.git*"}
local pattern_string
do
  local pattern_string0 = ""
  for _, pattern in ipairs(patterns) do
    pattern_string0 = (pattern_string0 .. " --glob='" .. pattern .. "'")
  end
  pattern_string = pattern_string0
end
local rg_string = "rg --line-number --with-filename"
vim.o.grepprg = (rg_string .. pattern_string)
return nil
