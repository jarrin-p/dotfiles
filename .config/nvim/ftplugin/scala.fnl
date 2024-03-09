(set vim.o.formatprg "scala-cli fmt -F --stdin -F --stdout")

(let [{: text_node : cleanup : snippet : add_snippets} (require :luasnip)
      text (text_node "#!/usr/bin/env -S scala-cli shebang -S 3")]
  (cleanup)
  (->> [(snippet :__shebang [text])]
       (add_snippets :scala)))

{}
; local group_id = vim.api.nvim_create_augroup('ScalaGroup', { clear = true })
