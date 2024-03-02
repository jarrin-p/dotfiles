(set vim.o.tabstop 2)

(let [ls (require :luasnip)
      text (ls.text_node "import (builtins.fetchTarball { url = \"https://api.github.com/repos/nixos/nixpkgs/tarball/23.11\"; }) {}")]
  (ls.cleanup)
  (->> [(ls.snippet :__nixpkgs_pin [text])]
       (ls.add_snippets :nix)))

{}
