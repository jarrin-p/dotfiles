(let [;{: info} (require :utils.log)
      {: setup-lsp} (require :utils.lsp-util)
      {: load-once} (require :utils.load-once)]
  (do
    (load-once :r #(setup-lsp :r_language_server {}))
    (set vim.o.sw 2)
    (set vim.o.ts 2)))
