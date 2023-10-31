do
  local cmd = {"lua-format", "-c", "$HOME/.luaformat"}
  vim.bo.formatprg = table.concat(cmd, " ")
end
return {}
