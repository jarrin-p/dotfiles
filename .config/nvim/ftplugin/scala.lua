local util = require("util")
vim.o.formatprg = "scala-cli fmt -F --stdin -F --stdout"
return {}
