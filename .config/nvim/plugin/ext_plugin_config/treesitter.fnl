;;; note: if there's an issue with treesitter parsing try
;;; uninstalling via nix collecting garbage re-installing.
;;; disable = { 'vim' }
(let [{: setup} (require :nvim-treesitter.configs)
      config {:highlight {:enable true :additional_vim_regex_highlighting true}
              :incremental_selection {:enable true
                                      :keymaps {:init_selection :gnn
                                                :node_incremental :grn
                                                :scope_incremental :grc
                                                :node_decremental :grm}}}]
  (setup config))

{}
