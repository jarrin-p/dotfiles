{:setup-lsp (fn [server-key setup-tbl]
              (let [{: setup} (. (require :lspconfig) server-key)
                    {:default_capabilities capabilities-fn} (require :cmp_nvim_lsp)
                    capabilities (-> (vim.lsp.protocol.make_client_capabilities)
                                     (capabilities-fn))]
                (do
                  (vim.notify "Starting Lsp")
                  (when (not setup-tbl.capabilities)
                    (set setup-tbl.capabilities capabilities))
                  (setup setup-tbl)
                  (vim.cmd :LspStart))))}
