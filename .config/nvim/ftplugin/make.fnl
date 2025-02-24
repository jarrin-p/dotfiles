(let [{: text : add-language-snippets} (require :utils.snippets)]
  (add-language-snippets :make
                         [[:__pandoc_md_to_pdf
                           [(text "%.pdf: %.md"
                                  "\tpandoc --from markdown --to pdf -o $@ @<")]]]))
