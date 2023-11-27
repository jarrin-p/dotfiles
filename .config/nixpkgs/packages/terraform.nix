{
  # https://lazamar.co.uk/nix-versions/ was used to find this version.
  # shoutout to the author for creating this.
  url ? "https://github.com/NixOS/nixpkgs/archive/4ab8a3de296914f3b631121e9ce3884f1d34e1e5.tar.gz",
  pkgs ? import (builtins.fetchTarball { url = url; }) {}
}:
  pkgs.terraform
