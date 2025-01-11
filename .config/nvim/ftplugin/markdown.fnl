(set vim.o.spell true)
(set vim.o.conceallevel 0)

(let [{:text_node text-node
       :insert_node insert-node
       : snippet
       : cleanup
       :add_snippets add-snippets} (require :luasnip)
      ;; I can't ever remember which goes where.
      link [(text-node "[")
            (insert-node 1 :text)
            (text-node "](")
            (insert-node 2 :url)
            (text-node ")")]]
  (cleanup)
  (->> [(snippet :__link link)]
       (add-snippets :markdown)))

{}
