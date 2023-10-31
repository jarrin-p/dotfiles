-- vim.cmd('syn clear markdownLink')
-- vim.cmd('syn region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")" contains=markdownUrl,mkJdtLink keepend contained')
-- vim.cmd('syntax match mkJdtLink /jdt://.*/ containedin=markdownLink conceal')

vim.cmd('syn keyword Error Exception exception EXCEPTION ERROR error Error CANCELED canceled CANCEL CANCELING cancel null NULL Null refused REFUSED Refused FAILURE FAILED')
vim.cmd('syn keyword Label INFO Info info RUNNING running Running')
vim.cmd('syn keyword Identifier port host hostname')
vim.cmd("syn match Error '.*Exception.*'")
