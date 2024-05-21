(let [luasnip (require :luasnip)
      {: text_node :insert_node ins : cleanup :add_snippets add-snippets :snippet build-snippet} luasnip]
  (fn text [...] (text_node [...]))

  (fn add-language-snippets [filetype snippets] "
  args
      filetype: string
          the filetype to load the snippets for.
      snippets: [[ invocation-name (string)
                   snippet (fn[luasnip]) -> [node] ]]
          array of small arrays. index 1 -> invocation name, index 2 -> fn returning nodes.
          the returned array should be snippet-nodes that actually build the snippet.
          this will be fed into the 'lifecycle' of creating snippets for a filetype.
      opts: table
  "
    (let [{} luasnip]
      (case (table.remove snippets)
        {1 invocation-name 2 snippet} (do
                                        (add-language-snippets filetype
                                                               snippets)
                                        (->> snippet
                                             (build-snippet invocation-name)
                                             (#[$1]) ; only takes arrays (tables), so convert it.
                                             (add-snippets filetype))
                                        {})
        _ (cleanup))))

  {: add-language-snippets : text : ins})
