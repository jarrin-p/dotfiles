(let [lspconfig (require :lspconfig)
      {:default_capabilities capabilities-fn} (require :cmp_nvim_lsp)
      ;; border [{"🭽" :FloatBorder}
      ;;         {"▔" :FloatBorder}
      ;;         {"🭾" :FloatBorder}
      ;;         {"▕" :FloatBorder}
      ;;         {"🭿" :FloatBorder}
      ;;         {"▁" :FloatBorder}
      ;;         {"🭼" :FloatBorder}
      ;;         {"▏" :FloatBorder}]
      capabilities (-> (vim.lsp.protocol.make_client_capabilities)
                       (capabilities-fn))
      servers {:ccls {}
               :cssls {:cmd [:css-languageserver :--stdio] : capabilities}
               :elmls {}
               :fennel_ls {:init_options {:fennel-ls {:extra-globals :vim}}}
               :hls {}
               :html {:cmd [:html-languageserver :--stdio] : capabilities}
               :lua_ls {:settings {:Lua {:diagnostics {:globals [:vim]
                                                       :workspace {:library {(vim.fn.expand :$VIMRUNTIME/lua) true
                                                                             (vim.fn.expand :$VIMRUNTIME/lua/vim/lsp) true}}}}}}
               :nickel_ls {}
               :nil_ls {}
               :sqlls {}
               :terraformls {}
               :texlab {}
               :ts_ls {:cmd [:typescript-language-server :--stdio]}
               :yamlls {}}]
  (each [server config (pairs servers)]
    (let [{: setup} (. lspconfig server)]
        (setup config))))

{}
