(let [;{: info} (require :utils.log)
      {: setup-lsp} (require :utils.lsp-util)
      {: load-once} (require :utils.load-once)
      settings {:sw 2 :ts 2}]
  (do
    (load-once :r #(setup-lsp :r_language_server {}))
    (each [k v (pairs settings)]
      (tset vim.o k v))))
