(let [cmp (require :cmp)
      ls (require :luasnip)
      behavior cmp.ConfirmBehavior.Replace
      select false
      <CR> (cmp.mapping.confirm {: behavior : select})]
  ;<Tab> (cmp.mapping #(if (ls.expand_or_jumpable) (ls.expand_or_jump) (cmp.visible) (cmp.select_next_item)))
  (cmp.setup {:experimental {:ghost_text false}
              :snippet {:expand #(ls.lsp_expand $1.body)}
              :mapping (cmp.mapping.preset.insert {: <CR>})
              :sources [{:name :luasnip}
                        {:name :nvim_lsp}
                        {:name :conjure}
                        {:name :nvim_lsp_signature_help}]}))

{}
