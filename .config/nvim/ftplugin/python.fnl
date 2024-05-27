(local {: info} (require :utils.log))
(fn setup-lsp [server-key setup-tbl]
  (let [{: setup} (. (require :lspconfig) server-key)
        {:default_capabilities capabilities-fn} (require :cmp_nvim_lsp)
        capabilities (-> (vim.lsp.protocol.make_client_capabilities)
                         (capabilities-fn))]
    (do
      (info #"python.fnl: calling setup")
      (when (not setup-tbl.capabilities)
        (set setup-tbl.capabilities capabilities))
      (setup setup-tbl))))

(do
  (info #"python.fnl: init")
  (let [{: load-once} (require :utils.load-once)
        {: util} (require :lspconfig)]
    (load-once :python #(setup-lsp :pyright {:root_dir util.find_git_ancestor})))
  (vim.cmd :LspStart)
  (set vim.bo.formatprg (table.concat [:black :-q "-"] " "))
  {})
