{
  pkgs ? import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/d8a5a620da8e1cae5348ede15cd244705e02598c"; }) {
    overlays =
      let
        conf = import ./.config/nixpkgs/paths.nix {};
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

          dots-script = prev.callPackage ./.config/nixpkgs/dots-script.nix {
            inherit (conf) colors;
            callerPath = toString ./default.nix;
          };

          git-root = (prev.writeShellScriptBin "git-root" ''${prev.git}/bin/git rev-parse --show-toplevel'');

          git-ui = prev.writeShellScriptBin "git-ui" ''
                git status > /dev/null 2>&1
                if test $? -ne 0
                then
                  echo "not a git repository, nothing to look at."
                  exit 1
                fi
                ${final.nvim}/bin/nvim +"Git" +"only"
          '';

          nvim = (prev.callPackage ./.config/nixpkgs/packages/nvim.nix {});

          # simple command for ensuring nvim can open.
          # eventually this should get moved into a test method when
          # building nvim.
          nvim-debug = let wrapped = wrapcmd "${final.nvim}/bin/nvim --headless"; in
            prev.writeShellScriptBin "nvim_d" ''
              if test "$1" = "--help"
              then
                  echo 'runs nvim and prints any messages to stdout.'
                  echo 'additional arguments/commands can be passed for specific testing.'
                  echo 'runs: nvim --headless $@ +q'
                  exit 0
              fi
              ${wrapped} +q
          '';


          tmux = prev.symlinkJoin {
            name = "tmux-join";
            paths = [
              (prev.tmux + /share)
              (prev.writeShellScriptBin "tmux" (wrapcmd "${prev.tmux}/bin/tmux -f ${conf.tmux}"))
            ];
          };

          tree = let script = prev.writeShellScriptBin
            "tree"
            (wrapcmd "${prev.tree}/bin/tree --dirsfirst -AC --prune" );
          in
            prev.symlinkJoin { name = "tree-join"; paths = [ (prev.tree + /share) script ]; };
        })
      ];
  }
}:
pkgs.callPackage ./.config/nixpkgs/main-env.nix {}
