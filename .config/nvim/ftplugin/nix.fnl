(set vim.o.tabstop 2)

(let [{:text_node text-node : snippet : cleanup :add_snippets add-snippets} (require :luasnip)
      nodes [(text-node "import (builtins.fetchTarball { url = \"https://api.github.com/repos/nixos/nixpkgs/tarball/23.11\"; }) {}")]
      fetchtar [(text-node ["builtins.fetchTarball {"
                             "\turl = \"\";"
                             "\tsha256 = \"\";"
                             "};"])]
      mk-derivation [(text-node ["pkgs.stdenv.mkDerivation {"
                                 "\t__noChroot = false;"
                                 ""
                                 "\tpname = \"\";"
                                 "\tversion = \"0.0.1\";"
                                 "\tsrc = ./.;"
                                 ""
                                 "\t# inputs unavailable at runtime, due to these inputs being specific to the native host platform."
                                 "\t# nativeBuildInputs = [];"
                                 ""
                                 "\tbuildInputs = with pkgs; [];"
                                 ""
                                 "\tbuildPhase = ''"
                                 "\t'';"
                                 ""
                                 "\tinstallPhase = ''"
                                 "\t\tmkdir -p $out"
                                 "\t'';"
                                 "};"])]]
  (cleanup)
  (->> [(snippet :__nixpkgs_pin nodes) (snippet :__fetchTar fetchtar) (snippet :__mkDerivation mk-derivation)]
       (add-snippets :nix)))

{}
