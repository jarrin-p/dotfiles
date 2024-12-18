(let [{: add-language-snippets : text : ins} (require :utils.snippets)]
  (do
    (vim.api.nvim_create_user_command :FF
                                      (fn [_]
                                        (_G.vim.cmd "silent w")
                                        (_G.vim.cmd "silent !fnlfmt --fix %"))
                                      {})
    (add-language-snippets :fennel
                           [[:__collect
                             [(text "(collect [k v (pairs ")
                              (ins 1 :tbl)
                              (text ")]" "\t(values k v))")]]
                            [:__icollect
                             [(text "(icollect [i v (ipairs ")
                              (ins 1 :array)
                              (text ")]" "\tv)")]]]))
  {})
