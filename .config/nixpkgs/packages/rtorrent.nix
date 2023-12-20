{
  pkgs ? import (builtins.fetchGit {
    name = "nixpkgs-23-11";
    url = "https://github.com/nixos/nixpkgs/";
    ref = "refs/tags/22.11";
  }) {}
}:
  pkgs.rtorrent
