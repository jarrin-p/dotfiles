let
  pkgs = import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/d8a5a620da8e1cae5348ede15cd244705e02598c"; }) {};
  callPackage = pkgs.callPackage;
  nvim = (callPackage ./packages/nvim.nix {});
  conf = {
    lf_config_home = builtins.path { name = "lf_config_home"; path = ../../.config; };
    tmux = builtins.path { name = "tmux_config"; path = ../tmux/.tmux.conf; };
  };
  bin = {
    bat = pkgs.writeShellScriptBin "bat" ''
      export BAT_THEME=TwoDark
      ${pkgs.bat}/bin/bat $@
    '';

    lf = pkgs.writeShellScriptBin "lf" ''
      export PATH=${pkgs.lf}/bin:${pkgs.coreutils-full}/bin:${pkgs.bash}/bin
      export LF_CONFIG_HOME=${conf.lf_config_home};
      export LF_CD_FILE=/tmp/.lfcd
      lf $@
      if test -s $LF_CD_FILE
      then
        echo $(realpath $(cat $LF_CD_FILE))
      else
        echo $(pwd)
      fi
      rm -f $LF_CD_FILE
    '';

    tmux = pkgs.writeShellScriptBin "tmux" ''
      ${pkgs.tmux}/bin/tmux -f ${conf.tmux} $@
    '';

    tree = pkgs.writeShellScriptBin "tree" ''
      ${pkgs.tree}/bin/tree --dirsfirst -AC --prune $@
    '';
  };
  commands = {
    als = pkgs.writeShellScriptBin "als" ''
      ${pkgs.coreutils-full}/bin/ls --group-directories-first --human-readable --color -al $@
    '';

    git-ui = pkgs.writeShellScriptBin "git-ui" ''
      git status > /dev/null 2>&1
      if test $? -ne 0
      then
        echo "not a git repository, nothing to look at."
      fi
      ${nvim}/bin/nvim +"Git" +"only"
    '';

    git-root = pkgs.writeShellScriptBin "git-root" ''
      ${pkgs.git}/bin/git rev-parse --show-toplevel
    '';

  };
in
  pkgs.buildEnv {
    name = "mainEnv";
    paths =
      (import ./packages/lsp.nix { pkgs = pkgs; }) ++
        [
          bin.bat
          bin.lf
          bin.tmux
          bin.tree
          commands.als
          commands.git-ui
          commands.git-root

          (pkgs.gradle_7.override{ java = pkgs.jdk11; })

          (callPackage ./packages/fennel.nix {})

          # version of rtorrent that doesn't break.
          (import ./packages/rtorrent.nix {})

          # version 1.15 of terraform.
          (import ./packages/terraform.nix {})

          pkgs.ansifilter # an actual savior.
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
