(set vim.o.tabstop 2)

(let [{:text_node text-node
       :insert_node insert-node
       : snippet
       : cleanup
       :add_snippets add-snippets} (require :luasnip)
      doctype [(text-node ["<!DOCTYPE html>"])]
      javascript-tag [(text-node ["<script type=\"text/javascript\" src=\""])
                      (insert-node 1 :index.js)
                      (text-node ["\"></script>"])]
      template [(text-node [:<html>
                            :<head>
                            :<title>some_title</title>
                            :</head>
                            :<body>
                            "<script src=\"your_script.js\"></script>"
                            :</body>
                            :</html>])]]
  (cleanup)
  (->> [(snippet :__doctype doctype)
        (snippet :__js-tag javascript-tag)
        (snippet :__template template)]
       (add-snippets :html)))

{}
