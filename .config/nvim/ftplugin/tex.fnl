(let [{: open} (require :io)
      pattern [:*.tex :*.sty]
      group (vim.api.nvim_create_augroup :TexBuildOnSave {})
      callback (case (open :Makefile :r)
                 (nil _) (do
                           (print "could not find Makefile for auto-run")
                           nil)
                 file (do
                        (file:close)
                        (print "found Makefile, will silently run `make build` on file save.")
                        #(vim.api.nvim_exec2 "silent make" {})))]
  (when callback
    (vim.api.nvim_create_autocmd [:BufWritePost]
                                 {: pattern : callback : group})))

{}
