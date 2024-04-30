(set vim.o.tabstop 2)

(let [{:text_node text-node : snippet : cleanup :add_snippets add-snippets} (require :luasnip)
      doctype [(text-node ["<!DOCTYPE html>"])]
      template [(text-node [:<html>
                            :<head>
                            :<title>some_title</title>
                            :</head>
                            :<body>
                            "<script src=\"your_script.js\"></script>"
                            :</body>
                            :</html>])]]
  (cleanup)
  (->> [(snippet :__doctype doctype) (snippet :__template template)]
       (add-snippets :html)))

{}
