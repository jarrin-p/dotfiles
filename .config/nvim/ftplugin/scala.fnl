(set vim.o.formatprg "scala-cli fmt -F --stdin -F --stdout")

(let [{: text : add-language-snippets : ins : text-array} (require :utils.snippets)]
  (add-language-snippets :scala
                         [[:__shebang
                           (text "#!/usr/bin/env -S scala-cli shebang -S 3")]]))

{}
; local group_id = vim.api.nvim_create_augroup('ScalaGroup', { clear = true })
