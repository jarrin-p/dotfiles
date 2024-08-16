{ pkgs ? import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/24.05"; }) {} }:
{
  shell = pkgs.mkShell {
    name = "shell";
    packages = [
      pkgs.lean4
    ];
  };
}
