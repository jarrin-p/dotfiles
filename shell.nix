{ pkgs ? import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/24.05"; }) {} }:
pkgs.mkShell {
  name = "lean-dev-env";
  packages = [
    pkgs.fennel
  ];
}
