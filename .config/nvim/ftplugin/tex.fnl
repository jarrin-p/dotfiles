(let [{: open} (require :io)
      {: INFO} vim.log.levels
      pattern [:*.tex :*.sty]
      group (vim.api.nvim_create_augroup :TexBuildOnSave {})
      callback (case (open :Makefile :r)
                 (nil _) (do
                           (vim.notify "could not find Makefile for auto-run" INFO)
                           nil)
                 file (do
                        (file:close)
                        (vim.notify "found Makefile, will silently run `make build` on file save." INFO)
                        #(vim.api.nvim_exec2 "silent make" {})))]
  (when callback
    (vim.api.nvim_create_autocmd [:BufWritePost]
                                 {: pattern : callback : group})))

{}
