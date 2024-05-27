(fn load-lsp [server-key setup-tbl]
  (let [{: setup} (. (require :lspconfig) server-key)
        {:default_capabilities capabilities-fn} (require :cmp_nvim_lsp)
        capabilities (-> (vim.lsp.protocol.make_client_capabilities)
                         (capabilities-fn))]
    (do
      (print :calling-setup)
      (when (not setup-tbl.capabilities)
        (set setup-tbl.capabilities capabilities))
      (setup setup-tbl))))

(do
  (print :loading-python-ft)
  (let [{: load-once} (require :utils.load-once)
        {: util} (require :lspconfig)]
    (load-once :python #(load-lsp :pyright {:root_dir util.find_git_ancestor})))
  (set vim.bo.formatprg (table.concat [:black :-q "-"] " "))
  {})
