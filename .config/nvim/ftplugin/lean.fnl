(set vim.o.tabstop 2)

(let [{: load-once} (require :utils.load-once)]
  (do
    (load-once :lean
               #(: (require :lean) :setup
                   {:ft {:nomodifiable {}}
                    :infoview {:autoopen false :width 20 :height 30}}))))

;; (let [{: text : add-language-snippets : ins : text-array} (require :utils.snippets)]
;;   (add-language-snippets :nix
;;                          [[:__nixpkgsPin
;;                            (text "import (builtins.fetchTarball { url = \"https://api.github.com/repos/nixos/nixpkgs/tarball/23.11\"; }) {}")]
;;                           [:__buildEnv
;;                            (text-array ["pkgs.buildEnv {"
;;                                         "\tname = \"\";"
;;                                         "\tpaths = [];"
;;                                         "};"])]
;;                           ]))

{}
