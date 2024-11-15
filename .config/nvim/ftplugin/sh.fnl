(let [{: text : text-array : add-language-snippets : ins : indent} (require :utils.snippets)]
  (do
    (-> (require :lspconfig) (. :bashls) (: :setup))
    (add-language-snippets :sh
                           [[:__case
                             [(text "case \"")
                              (ins 1 :WORD)
                              (text-array ["\" in"
                                           (indent 1 "*)")
                                           (indent 2 "echo \"default case\"")
                                           (indent 2 ";;")
                                           :esac])]]
                            [:__argparse_light
                             [(text-array ["while ! test -z \"$1\""
                                           :do
                                           (indent 1 "case \"$1\" in")
                                           (indent 2 "*)")
                                           (indent 3 "echo 'default case'")
                                           (indent 3 ";;")
                                           (indent 1 :esac)
                                           (indent 1 :shift)
                                           :done])]]])))

{}
