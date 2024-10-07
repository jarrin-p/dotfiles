{
  pkgs ? import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/d8a5a620da8e1cae5348ede15cd244705e02598c"; }) {
    overlays =
      let
        wrapcmd = (import ./.config/nixpkgs/util.nix).wrapcmd;
      in
        [ (final: prev: {
          als = prev.writeShellScriptBin "als" ''
            ${prev.coreutils-full}/bin/ls --group-directories-first --human-readable --color -al
          '';

          bat = let
            wrapped = wrapcmd "${prev.bat}/bin/bat";
            script = prev.writeShellScriptBin "bat" ''
              echo 'im an overlay, bitch'
              export BAT_THEME=TwoDark
              ${wrapped}
            '';
          in
            prev.symlinkJoin { name = "bat-join"; paths = [ (prev.bat + /share) script ]; };

          tree = let script = prev.writeShellScriptBin
            "tree"
            (wrapcmd "${prev.tree}/bin/tree --dirsfirst -AC --prune" );
          in
            prev.symlinkJoin { name = "tree-join"; paths = [ (prev.tree + /share) script ]; };
        })
      ];
  }
}:
pkgs.callPackage ./.config/nixpkgs/main-env.nix {
  callerPath = toString ./default.nix;
}
