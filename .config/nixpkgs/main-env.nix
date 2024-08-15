let
  pkgs = import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/d8a5a620da8e1cae5348ede15cd244705e02598c"; }) {};
  callPackage = pkgs.callPackage;
  nvim = (callPackage ./packages/nvim.nix {});
  conf = {
    tmux = builtins.path { name = "tmux_config"; path = ../tmux/.tmux.conf; };
  };
  wrapped = {
    tmux = pkgs.writeShellScriptBin "tmux" ''${pkgs.tmux}/bin/tmux -f ${conf.tmux} $@'';
  };
  commands = {
    gitroot = pkgs.writeShellScriptBin "g" ''
      git status > /dev/null 2>&1
      if test $? -ne 0
      then
        echo "not a git repository, nothing to look at."
      fi
      ${nvim}/bin/nvim +"Git" +"only"
    '';
  };
in
  pkgs.buildEnv {
    name = "mainEnv";
    paths =
      (import ./packages/lsp.nix { pkgs = pkgs; }) ++
        [
          commands.gitroot
          wrapped.tmux

          (pkgs.gradle_7.override{ java = pkgs.jdk11; })

          (callPackage ./packages/fennel.nix {})

          # version of rtorrent that doesn't break.
          (import ./packages/rtorrent.nix {})

          # version 1.15 of terraform.
          (import ./packages/terraform.nix {})

          pkgs.ansifilter # an actual savior.
          pkgs.bat
          pkgs.bitwarden-cli
          pkgs.code-minimap
          pkgs.coreutils-full
          pkgs.coursier
          pkgs.curl
          pkgs.direnv
          pkgs.ffmpeg
          pkgs.fd
          pkgs.fish
          pkgs.fnlfmt
          pkgs.fzf
          pkgs.gettext
          pkgs.gh
          pkgs.git
          pkgs.glow
          pkgs.gnumake
          pkgs.gum
          pkgs.haskellPackages.hoogle
          pkgs.jq
          pkgs.lf
          pkgs.moar
          pkgs.neovim-remote
          pkgs.nodePackages_latest.pyright
          pkgs.pylint
          pkgs.python311Packages.sqlparse
          pkgs.python310
          pkgs.readline
          pkgs.redis
          pkgs.rename
          pkgs.ripgrep
          pkgs.sd
          pkgs.stow
          pkgs.tree
          pkgs.universal-ctags
          pkgs.visidata
          pkgs.wget
          pkgs.yq
        ];
}
# broken packages.
# pkcs11helper
# luaformatter
# nvimpager
