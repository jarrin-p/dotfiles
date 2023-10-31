do
  local cmd = {"sqlformat", "-", "-a"}
  vim.bo.formatprg = table.concat(cmd, " ")
end
return {}
