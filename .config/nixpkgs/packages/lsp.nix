{
  callPackage,
  ccls,
  haskell-language-server,
  llvmPackages_16,
  nil,
  nls,
  nodePackages_latest,
  sumneko-lua-language-server,
  terraform-ls,
  yaml-language-server
}:
let
  bins = [
    ccls
    haskell-language-server
    llvmPackages_16.clang-unwrapped
    nil # nix language server.
    nls
    sumneko-lua-language-server
    terraform-ls
    yaml-language-server
  ];

  imports = [
    # java jdlts with lombok enabled.
    (callPackage ./jdtls/default.nix {})
    (let
       fnlNixPkgsUrl = "https://api.github.com/repos/nixos/nixpkgs/tarball/7cc549772d12d0e3aceafa2eef2fd6b44fd1eafe";
     in (import (builtins.fetchTarball { url = fnlNixPkgsUrl; }) {}).fennel-ls)
  ];

  nodeBins = with nodePackages_latest; [
    dockerfile-language-server-nodejs
    pyright
    typescript-language-server
    vscode-css-languageserver-bin
    vscode-html-languageserver-bin
    vscode-json-languageserver
  ];
in
  bins ++ imports ++ nodeBins
