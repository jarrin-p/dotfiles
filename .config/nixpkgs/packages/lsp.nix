{ pkgs }:
let
  bins = with pkgs; [
    nil # nix language server.
    nls
    sumneko-lua-language-server
    terraform-ls
    haskell-language-server
  ];
  nodeLS = with pkgs.nodePackages_latest; [
    vscode-css-languageserver-bin
    vscode-json-languageserver
    vscode-html-languageserver-bin
    typescript-language-server
    dockerfile-language-server-nodejs
  ];

  imports = [
    # java jdlts with lombok enabled.
    (import ./jdtls/default.nix { pkgs = pkgs; })
  ];
in
  bins ++ nodeLS ++ imports
