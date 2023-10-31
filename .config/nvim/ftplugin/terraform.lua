do
  local cmd = {"terraform", "fmt", "-"}
  vim.bo.formatprg = table.concat(cmd, " ")
end
vim.bo.tabstop = 2
return {}
