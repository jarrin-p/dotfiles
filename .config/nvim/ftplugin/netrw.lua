do
  local util = require("util")
  vim.wo.relativenumber = true
  util.buf_nnoremap("<c-l>", "<c-w>w")
  util.buf_nnoremap("<c-h>", "<c-w>W")
  util.buf_nnoremap("dd", "D")
  util.buf_nnoremap("cw", "R")
  util.buf_nnoremap("r", "gn")
  util.buf_nnoremap("R", "<c-l>")
  util.buf_nnoremap("bm", "mb")
end
return {}
