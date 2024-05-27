(let [{: info} (require :utils.log)
      {: setup-lsp} (require :utils.lsp-util)]
  (do
    (info #"python.fnl: init")
    (let [{: load-once} (require :utils.load-once)
          {: util} (require :lspconfig)]
      (load-once :python
                 #(setup-lsp :pyright {:root_dir util.find_git_ancestor})))
    (vim.cmd :LspStart)
    (set vim.bo.formatprg (table.concat [:black :-q "-"] " "))
    {}))
