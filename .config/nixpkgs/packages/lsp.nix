{ pkgs }:
let
  bins = with pkgs; [
    haskell-language-server
    llvmPackages_9.clang-unwrapped
    nil # nix language server.
    nls
    sumneko-lua-language-server
    terraform-ls
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
