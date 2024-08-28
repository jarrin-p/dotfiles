{
  callPackage,
  ccls,
  haskell-language-server,
  llvmPackages_16,
  nil,
  nls,
  sumneko-lua-language-server,
  terraform-ls,
  yaml-language-server,
  nodePackages_latest 
}:
let
  fnlNixPkgsUrl = "https://api.github.com/repos/nixos/nixpkgs/tarball/7cc549772d12d0e3aceafa2eef2fd6b44fd1eafe";
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
  nodeBins = with nodePackages_latest; [
    vscode-css-languageserver-bin
    vscode-json-languageserver
    vscode-html-languageserver-bin
    typescript-language-server
    dockerfile-language-server-nodejs
    pyright
  ];

  imports = [
    # java jdlts with lombok enabled.
    (callPackage ./jdtls/default.nix {})
    (import (builtins.fetchTarball { url = fnlNixPkgsUrl; }) {}).fennel-ls
  ];
in
  bins ++ nodeBins ++ imports
