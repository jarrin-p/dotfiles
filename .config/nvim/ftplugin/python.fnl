(let [{: info} (require :utils.log)
      {: setup-lsp} (require :utils.lsp-util)
      {: load-once} (require :utils.load-once)
      {: util} (require :lspconfig)]
  (do
    (info #"python.fnl: init")
    (load-once :python #(setup-lsp :pyright {:root_dir util.find_git_ancestor}))
    (set vim.bo.formatprg "black -q -")
    {}))
