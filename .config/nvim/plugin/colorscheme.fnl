(each [k v (pairs {;;
                   ;; syntax
                   :Conditional {:ctermfg 9}
                   :Character {:ctermfg 12 :italic true}
                   :Comment {:ctermfg 8 :italic true}
                   :Constant {:ctermfg 12}
                   :Delimiter {:ctermfg 15}
                   :Operator {:ctermfg 10}
                   :String {:ctermfg 5 :italic true}
                   :Type {:ctermfg 11 :italic true}
                   :Statement {:ctermfg 13 :italic true}
                   :Whitespace {:ctermfg 9}
                   ;; language specific
                   ;; scala
                   :scalaSquareBracketsBrackets {:link :Delimiter}
                   :scalaNameDefinition {:link "@variable"}
                   :scalaKeywordModifier {}
                   "@lsp.type.modifier.scala" {:ctermfg 9}
                   "@lsp.type.keyword.scala" {:link :Statement}
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
                   :FloatBorder {:ctermfg 5}
                   :Folded {:link :Comment}
                   :LineNr {:ctermfg 8}
                   :MsgArea {:ctermfg 15 :ctermbg 0}
                   :Search {:underline true :italic true :bold true}
                   :SpecialKey {:ctermfg 13}})]
  (vim.api.nvim_set_hl 0 k v))
