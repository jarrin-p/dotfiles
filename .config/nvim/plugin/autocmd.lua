local util = require("utils")
do
  local au
  local function _1_(events, opts)
    return _G.vim.api.nvim_create_autocmd(events, opts)
  end
  au = _1_
  au({"BufWinLeave"}, {pattern = {".*", "*"}, command = "if expand(\"%\") != \"\" | silent! mkview | endif"})
  au({"BufWinEnter"}, {pattern = {".*", "*"}, command = "if expand(\"%\") != \"\" | silent! loadview | endif"})
  au({"DirChanged", "VimLeave"}, {callback = util.export_cwd})
  au({"BufWinEnter"}, {pattern = {"*.flinklog"}, command = "runtime! after/syntax/flinklog.lua"})
  au({"BufWinEnter"}, {pattern = {"*.rangerconf"}, command = "runtime! after/syntax/rangerconf.lua"})
  au({"BufWinEnter"}, {pattern = {"*.velocity"}, command = "runtime! after/syntax/velocity.lua"})
end
return vim.cmd("augroup CursorLine\n    au!\n    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline\n    au WinLeave * setlocal nocursorline\naugroup END")
