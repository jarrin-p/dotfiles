(let [{: load-once} (require :utils.load-once)
      {: setup-lsp} (require :utils.lsp-util)]
  (do
    (load-once :rust #(setup-lsp :rust_analyzer {}))
    (set vim.bo.formatprg :rustfmt))
  (let [{: text : add-language-snippets : ins} (require :utils.snippets)]
    (add-language-snippets :rust
                           [[:__setup-tests
                             (text "#[cfg(test)]"
                                   "mod tests {"
                                   "\tuse super::*;"
                                   "}")]

                            [:__new-test
                             [(text "#[test]"
                                    "fn ")
                              (ins 1 :test_name)
                              (text "() {"
                                    "\t")
                              (ins 2 "// test logic")
                              (text ""
                                    "}")]]])))

{}
