{
  pkgs ? import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/d8a5a620da8e1cae5348ede15cd244705e02598c"; }) {}
}:
pkgs.callPackage ./.config/nixpkgs/main-env.nix {
  callerPath = toString ./default.nix;
}
