(let [cmd [:lua-format :-c :$HOME/.luaformat]]
  (set vim.bo.formatprg (table.concat cmd " ")))
{}
