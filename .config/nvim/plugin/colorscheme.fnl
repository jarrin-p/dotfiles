(each [k v (pairs {;;
                   ;; syntax
                   :Character {:ctermfg 12}
                   :Comment {:ctermfg 8 :italic true}
                   :Constant {:ctermfg 12}
                   :String {:ctermfg 5}
                   :Type {:ctermfg 11}
                   ;;
                   ;; vim
                   :CurSearch {:ctermbg 8
                               :underline true
                               :italic true
                               :bold true}
                   :DiffAdd {:ctermfg 2}
                   :DiffAdded {:link :DiffAdd}
                   :DiffChange {:ctermbg 9}
                   :DiffDelete {:ctermfg 1}
                   :DiffRemoved {:ctermfg 1}
                   :DiffText {:ctermfg 9}
                   :EndOfBuffer {:ctermfg 0}
                   :Folded {:link :Comment}
                   :LineNr {:ctermfg 9}
                   :MsgArea {:ctermfg 15 :ctermbg 0}
                   :Search {:underline true :italic true :bold true}
                   :SpecialKey {:ctermfg 13}
                   :Statement {:ctermfg 13}
                   :Whitespace {:ctermfg 9}})]
  (vim.api.nvim_set_hl 0 k v))
