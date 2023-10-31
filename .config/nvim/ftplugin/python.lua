local cmd = {"black", "-q", "-"}
vim.bo.formatprg = table.concat(cmd, " ")
return nil
