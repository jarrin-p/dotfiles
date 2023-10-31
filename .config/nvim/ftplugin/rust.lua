do
  local cmd = {"rustfmt", "%"}
  vim.bo.formatprg = table.concat(cmd, " ")
end
return {}
