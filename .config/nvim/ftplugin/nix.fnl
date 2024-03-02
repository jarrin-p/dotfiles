(set vim.o.tabstop 2)

(let [ls (require :luasnip)
      new-snippet ls.snippet
      text (ls.text_node "import (builtins.fetchTarball { url = \"https://api.github.com/repos/nixos/nixpkgs/tarball/23.11\"; }) {}")
      i ls.insert_node]
  (ls.cleanup)
  (->> [(new-snippet :__nixpkgs_pin [text])]
       (ls.add_snippets :nix)))

{}
