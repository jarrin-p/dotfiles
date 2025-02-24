(set vim.o.spell true)
(set vim.o.conceallevel 0)

(let [{: text : add-language-snippets : ins} (require :utils.snippets)]
  (add-language-snippets :markdown
                         [[:__link
                           [(text "[")
                            (ins 1 :text)
                            (text "](")
                            (ins 2 :url)
                            (text ")")]]
                          ;; for use with pandoc in the header
                          [:__header_margins [(text "geometry: margin=1in")]]]))

{}
