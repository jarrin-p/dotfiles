(let [lspconfig (require :lspconfig)
      {:default_capabilities capabilities-fn} (require :cmp_nvim_lsp)
      capabilities (-> (vim.lsp.protocol.make_client_capabilities)
                       (capabilities-fn))
      servers {:ccls {}
               :cssls {:cmd [:css-languageserver :--stdio] : capabilities}
               :elmls {}
               :fennel_ls {:init_options {:fennel-ls {:extra-globals :vim}}}
               :hls {}
               :html {:cmd [:html-languageserver :--stdio] : capabilities}
               :jsonls {:cmd [:vscode-json-languageserver :--stdio]}
               :lua_ls {:settings {:Lua {:diagnostics {:globals [:vim]
                                                       :workspace {:library {(vim.fn.expand :$VIMRUNTIME/lua) true
                                                                             (vim.fn.expand :$VIMRUNTIME/lua/vim/lsp) true}}}}}}
               :nickel_ls {}
               :nil_ls {}
               :sqlls {}
               :terraformls {}
               :texlab {}
               :tsserver {:cmd [:typescript-language-server :--stdio]}
               :yamlls {}}]
  (each [server config (pairs servers)]
    (let [{: setup} (. lspconfig server)]
      (setup config))))

{}
