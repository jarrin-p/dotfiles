(set vim.o.tabstop 2)

;; todo - reduce boilerplate.
;; probably just need a few functions with varargs to handle everything requiring an array.
(let [{:text_node text-node : snippet : cleanup :add_snippets add-snippets} (require :luasnip)
      nixpkgs-pin [(text-node "import (builtins.fetchTarball { url = \"https://api.github.com/repos/nixos/nixpkgs/tarball/23.11\"; }) {}")]
      ghc-with-pkgs [(text-node ["(haskellPackages.ghcWithPackages (pkgs: [pkgs.aeson]))"])]
      fetchtar [(text-node ["builtins.fetchTarball {"
                             "\turl = \"\";"
                             "\tsha256 = \"\";"
                             "};"])]
      build-env [(text-node ["pkgs.buildEnv {"
                             "\tname = \"\";"
                             "\tpaths = [];"
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
  (->> [(snippet :__nixpkgsPin nixpkgs-pin)
        (snippet :__fetchTar fetchtar)
        (snippet :__mkDerivation mk-derivation)
        (snippet :__buildEnv build-env)
        (snippet :__ghcWithPkgs ghc-with-pkgs)]
       (add-snippets :nix)))

{}
