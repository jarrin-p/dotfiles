(let [config {:Comment {:ctermfg 8 :italic true}
              :Constant {:ctermfg 12}
              :CurSearch {:ctermbg 8 :underline true :italic true :bold true}
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
              :String {:ctermfg 5}
              :Whitespace {:ctermfg 9}}]
  (each [k v (pairs config)]
    (vim.api.nvim_set_hl 0 k v)))
