local function _1_(_)
  _G.vim.cmd("w")
  return _G.vim.cmd("!fnlfmt --fix %")
end
return vim.api.nvim_create_user_command("FF", _1_, {})
