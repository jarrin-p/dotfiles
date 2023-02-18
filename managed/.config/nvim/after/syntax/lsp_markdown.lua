vim.cmd('syn clear markdownLink')
vim.cmd(
    'syn region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")" contains=markdownUrl,mkJdtLink keepend contained')
vim.cmd('syntax match mkJdtLink /jdt://.*/ containedin=markdownLink conceal')
