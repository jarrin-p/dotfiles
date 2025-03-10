{
  commit ? "7243daf549a0b69bd0f11a43401cadd86b4f2ef0",
  pkgs ? import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/${commit}"; }) {
    overlays =
      let
        conf = import ./.config/nixpkgs/paths.nix {};
        wrapcmd = (import ./.config/nixpkgs/util.nix).wrapcmd;
      in
        [ (final: prev: {
          aichat = let
            pkgs = import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/6c21d3e5332aadb0d0818bfbc79684c8d1b089f4"; }) {};
          in pkgs.aichat;

          als = prev.writeShellScriptBin "als" ''
            ${prev.coreutils-full}/bin/ls --group-directories-first --human-readable --color -al $@
          '';

          # bash-language-server = pkgs.nodePackages_latest.bash-language-server;

          bat-overlay = let
            wrapped = wrapcmd "${prev.bat}/bin/bat";
            script = prev.writeShellScriptBin "bat" ''
              export BAT_THEME=TwoDark
              ${wrapped}
            '';
          in
            prev.symlinkJoin { name = "bat-join"; paths = [ (prev.bat + /share) script ]; };

          dots-script = prev.callPackage ./.config/nixpkgs/dots-script.nix {
            inherit (conf) colors;
            callerPath = toString ./default.nix;
          };

          git-root = prev.writeShellScriptBin "git-root" ''${prev.git}/bin/git rev-parse --show-toplevel'';

          git-ui = prev.writeShellScriptBin "git-ui" ''
                git status > /dev/null 2>&1
                if test $? -ne 0
                then
                  echo "not a git repository, nothing to look at."
                  exit 1
                fi
                nvim +"Git" +"only"
          '';

          lf-overlay = let script = prev.writeShellScriptBin "lf" ''
              export PATH=${prev.lf}/bin:${prev.coreutils-full}/bin:${prev.bash}/bin:/usr/bin
              export LF_CONFIG_HOME="${conf.lf_config_home}";
              export LF_CD_FILE=/tmp/.lfcd
              lf $@
              if test -s "$LF_CD_FILE"
              then
                echo $(realpath "$(cat "$LF_CD_FILE")")
              else
                echo "$(pwd)"
              fi
              rm -f "$LF_CD_FILE"
            '';
          in
            prev.symlinkJoin { name = "lf-join"; paths = [ (prev.lf + /share) script ]; };

          # build the hacky export string.
          # direnv only supports passing configuration (direnvrc) through XDG_CONFIG_HOME/direnv/direnvrc,
          # this is pretty much an ugly hack to allow direnv to stay isolated in nix, by altering
          # the sourced hook function to include an export before the `direnv` binary is called.
          nix-denv = prev.runCommand "nix-direnv-as-xdg" {} ''
              mkdir -p $out/direnv
              cp ${prev.nix-direnv}/share/nix-direnv/direnvrc $out/direnv/direnvrc
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
