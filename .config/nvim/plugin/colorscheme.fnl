(let [fg :ctermfg
      bg :ctermbg
      config {:Comment {fg 8 :italic true}
              :Constant {fg 12}
              :CurSearch {bg 9 :underline true :italic true :bold true}
              :DiffAdd {bg 2}
              :DiffAdded {:link :DiffAdd}
              :DiffChange {bg 9}
              :DiffDelete {bg 1 fg 1}
              :DiffRemoved {bg 1}
              :DiffText {bg 9}
              :EndOfBuffer {fg 0}
              :Folded {:link :Comment}
              :LineNr {fg 9}
              :MsgArea {fg 15 bg 0}
              :Search {:underline true :italic true}
              :SpecialKey {fg 13}
              :Statement {fg 13}
              :String {fg 5}
              :Whitespace {fg 9}}]
  (each [k v (pairs config)]
    (vim.api.nvim_set_hl 0 k v)))
