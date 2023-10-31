(let [cmd [:sqlformat "-" :-a]] (set vim.bo.formatprg (table.concat cmd " ")))
{}
