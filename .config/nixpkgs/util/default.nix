{pkgs ? import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/24.05"; }) {}}:
#{ runCommand, lean4 }:
pkgs.stdenv.mkDerivation {
  __noChroot = true; # leanmake uses /usr/bin/env which is intentionally unused behind nix sandbox.

  pname = "lean-builder";
  version = "0.0.1";
  src = ./.;
  buildInputs = [pkgs.lean4 pkgs.coreutils-full];
  dontUnpack = false;

  installPhase = ''
    export PATH=$PATH:${pkgs.lean4}/bin:${pkgs.coreutils-full}/bin
    mkdir -p $out/bin
    lake build
    mv .lake/build/bin/vimprep $out/bin/prepvim
    rm -rf build
  '';
}
