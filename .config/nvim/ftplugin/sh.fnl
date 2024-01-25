(set vim.o.makeprg "tmux send-keys -t 1 'sh %' enter")
(let [ls (require :luasnip)
      s ls.snippet
      t ls.text_node
      i ls.insert_node
      case-stmnt (let [phrase :.case
                       switch (t ["case \""])
                       var-name (i 1 "WORD")
                       in (t ["\" in" "    *)" "        echo \"default case\"" "        ;;"])
                       starting-pos (i 0)
                       t-end (t ["" "esac"])]
                   (s phrase [switch var-name in starting-pos t-end]))]
  (ls.cleanup)
  (ls.add_snippets :sh [case-stmnt]))

{}
