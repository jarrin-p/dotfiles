{ pkgs }:
let
  fennelNixpkgs = import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/7cc549772d12d0e3aceafa2eef2fd6b44fd1eafe"; }) {};
  bins = [
    fennelNixpkgs.fennel-ls
    pkgs.ccls
    pkgs.haskell-language-server
    pkgs.llvmPackages_16.clang-unwrapped
    pkgs.nil # nix language server.
    pkgs.nls
    pkgs.sumneko-lua-language-server
    pkgs.terraform-ls
    pkgs.yaml-language-server
  ];
  nodeBins = with pkgs.nodePackages_latest; [
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
  bins ++ nodeBins ++ imports
