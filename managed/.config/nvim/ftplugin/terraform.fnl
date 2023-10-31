(let [cmd [:terraform :fmt "-"]] (set vim.bo.formatprg (table.concat cmd " ")))
(set vim.bo.tabstop 2)
{}
