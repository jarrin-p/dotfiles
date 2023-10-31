(let [cmd [:rustfmt "%"]] (set vim.bo.formatprg (table.concat cmd " ")))
{}
