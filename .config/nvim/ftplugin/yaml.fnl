(set vim.o.tabstop 2)

(let [{:text_node text-node : snippet : cleanup :add_snippets add-snippets} (require :luasnip)
      docker-compose-ml [(text-node ["# yaml-language-server: $schema=https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"])]]
  (cleanup)
  (->> [(snippet :__dockerComposeModeline docker-compose-ml)]
       (add-snippets :yaml)))

{}
