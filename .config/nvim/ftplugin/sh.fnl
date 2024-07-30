(let [ls (require :luasnip)
      new-snippet ls.snippet
      t ls.text_node
      i ls.insert_node
      case-stmnt (let [key :.case
                       switch (t ["case \""])
                       var-name (i 1 :WORD)
                       in (t ["\" in"
                              "    *)"
                              "        echo \"default case\""
                              "        ;;"])
                       starting-pos (i 0)
                       t-end (t ["" :esac])]
                   (new-snippet key [switch var-name in starting-pos t-end]))
      argparse (new-snippet :.argparse
                            [(t ["while ! test -z \"$1\""
                                 :do
                                 "\tcase \"$1\" in"
                                 "\t\t*)"
                                 "\t\t\techo 'default case'"
                                 "\t\t\t;;"
                                 "\tesac"
                                 "\tshift"
                                 :done])])]
  (ls.cleanup)
  (ls.add_snippets :sh [case-stmnt argparse]))

{}
