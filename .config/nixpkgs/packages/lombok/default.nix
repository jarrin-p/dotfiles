{ bash, coreutils }:
let
  lombok = builtins.fetchurl "https://projectlombok.org/downloads/lombok.jar";
in
derivation {
  name = "lombok";
  system = builtins.currentSystem;

  inherit bash coreutils lombok;

  builder = "${bash}/bin/bash";
  args = [ ./builder.sh ];
}

