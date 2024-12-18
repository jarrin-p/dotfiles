{
  callPackage,
  ccls,
  haskell-language-server,
  llvmPackages_16,
  nil,
  nls,
  nodePackages_latest,
  pyright,
  sumneko-lua-language-server,
  terraform-ls,
  vscode-langservers-extracted,
  yaml-language-server
}:
let
  bins = [
    ccls
    haskell-language-server
    llvmPackages_16.clang-unwrapped
    nil # nix language server.
    nls
    pyright
    sumneko-lua-language-server
    terraform-ls
    vscode-langservers-extracted
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
    typescript-language-server
  ];
in
  bins ++ imports ++ nodeBins
