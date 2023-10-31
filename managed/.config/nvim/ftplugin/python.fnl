(let [cmd [:black :-q "-"]] (set vim.bo.formatprg (table.concat cmd " ")))
