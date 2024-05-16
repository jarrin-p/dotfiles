(let [{: open} (require :io)
      pattern [:*.tex :*.sty]
      group (vim.api.nvim_create_augroup :TexBuildOnSave {})
      callback (case (open :Makefile :r)
                 [nil err] (print err)
                 _ #(vim.api.nvim_exec2 "silent make" {}))]
  (vim.api.nvim_create_autocmd [:BufWritePost] {: pattern : callback : group}))

{}
