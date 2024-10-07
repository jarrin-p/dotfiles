{
  pkgs ? import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/d8a5a620da8e1cae5348ede15cd244705e02598c"; }) {
    overlays = [ (final: prev: {
      bat = let
        wrapped = (import ./.config/nixpkgs/util.nix).wrapcmd "${prev.bat}/bin/bat";
        script = prev.writeShellScriptBin "bat" ''
          echo 'im an overlay, bitch'
          export BAT_THEME=TwoDark
          ${wrapped}
        '';
      in
        prev.symlinkJoin { name = "bat-join"; paths = [ (prev.bat + /share) script ]; };
    }) ];
  }
}:
pkgs.callPackage ./.config/nixpkgs/main-env.nix {
  callerPath = toString ./default.nix;
}
