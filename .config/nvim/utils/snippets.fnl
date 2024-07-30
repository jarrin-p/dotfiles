(let [luasnip (require :luasnip)
      {: text_node
       :insert_node ins
       : cleanup
       :add_snippets add-snippets
       :snippet build-snippet} luasnip]
  (fn indent [amt text state]
    "create indentation for a specified number of tabstops."
    (case [amt state]
      [0 nil] text
      [i nil] (indent (- i 1) text (.. "\t"))
      [0 state#] (.. state# text)
      [i state#] (indent (- i 1) text (.. state# "\t"))))

  (fn text [...]
    "alias for text_node. allows string args to be var-args instead of an array."
    (text_node [...]))

  (fn add-language-snippets [filetype snippets]
    "
    args
        filetype: string
            the filetype to load the snippets for.
        snippets: [[ invocation-name (string)
                     snippet (fn[] -> [node]) ]]
            array of 2-element arrays. index 1 -> invocation name, index 2 -> fn returning nodes.
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
                                             (#[$1]) ; processing one at a time but it only takes arrays (tables), so convert it.
                                             (add-snippets filetype))
                                        {})
        _ (cleanup))))

  {: add-language-snippets : text : ins : indent :text-array text_node})
