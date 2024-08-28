let
  pkgs = import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/d8a5a620da8e1cae5348ede15cd244705e02598c"; }) {};
  callPackage = pkgs.callPackage;

  setenv = ''
    export PAGER=${bin.bat}/bin/bat
    export MANPAGER="${bin.bat}/bin/bat --wrap never"
    export EDITOR=${bin.nvim}/bin/nvim
    export VISUAL=${bin.nvim}/bin/nvim
    export NIX_DIRENV_LOCATION="${nix-direnv}"
    export DIRENV_BIN="${bin.direnv}/bin/direnv"
    export FZF_DEFAULT_COMMAND="rg --glob '!*.git' --glob '!*.class' --glob '!*.jar' --glob '!*.java.html' --files --hidden"
    export NIX_USER_CONF_FILES=${conf.nixconf}
  '';

  # build the hacky export string.
  # direnv only supports passing configuration (direnvrc) through XDG_CONFIG_HOME/direnv/direnvrc,
  # this is pretty much an ugly hack to allow direnv to stay isolated in nix, by altering
  # the sourced hook function to include an export before the `direnv` binary is called.
  nix-direnv = pkgs.runCommand "nix-direnv-as-xdg" {} ''
      mkdir -p $out/direnv
      cp ${pkgs.nix-direnv}/share/nix-direnv/direnvrc $out/direnv/direnvrc
  '';

  conf = {
    # want the helper tool to notice updates. if this were a path,
    # it would be stored in the nix-store, and thus would never look like
    # it changes.
    this = toString ./main-env.nix;

    root = ../../../dotfiles;

    fishhook = ./packages/fish;

    lf_config_home = builtins.path { name = "lf_config_home"; path = ../../.config; };
    tmux = builtins.path { name = "tmux_config"; path = ../tmux/.tmux.conf; };
    nixconf = ../nix/nix.conf;
    fish = ../fish/config.fish;
  };

  # helper for wrapping commands while preserving script input arguments.
  # `bash` automatically splits strings into lists, i.e. ./script "hello world" is
  # processed as a script with two arguments. this function works around that.
  wrapcmd = cmd: ''eval "${cmd} ''${*@Q}"'';

  bin = {
    bat = let
      wrapped = wrapcmd "${pkgs.bat}/bin/bat";
      script = (pkgs.writeShellScriptBin "bat" ''
        export BAT_THEME=TwoDark
        ${wrapped}
      '');
    in
      pkgs.symlinkJoin { name = "bat-join"; paths = [ (pkgs.bat + /share) script ]; };

    # make sure the same direnv gets used everywhere, even though it's not
    # actually modified at all.
    direnv = pkgs.direnv;

    dots = (callPackage ./dots.nix { configLocation = conf.this; });

    # load env vars before loading fish shell.
    # this allows other shells to use them upon invocation as well, without having
    # to have a lot of duplicate rcs for the preferences.
    fish = let
      script = pkgs.writeShellScriptBin "fish" ''
        ${setenv}
        ${pkgs.fish}/bin/fish --init-command="source ${conf.fish} && source ${conf.fishhook}/direnv-hook.fish" $@
      '';
    in
      pkgs.symlinkJoin { name = "fish-join"; paths = [ (pkgs.fish + /share) script ]; };

    lf = let script = pkgs.writeShellScriptBin "lf" ''
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
    in
      pkgs.symlinkJoin { name = "lf-join"; paths = [ (pkgs.lf + /share) script ]; };

    nvim = (callPackage ./packages/nvim.nix {});

    # simple command for ensuring nvim can open.
    # eventually this should get moved into a test method when
    # building nvim.
    nvim-debug = pkgs.writeShellScriptBin "nvim_d" ''
      ${bin.nvim}/bin/nvim --headless +q
    '';

    tmux = pkgs.symlinkJoin {
      name = "tmux-join";
      paths = [
        (pkgs.tmux + /share)
        (pkgs.writeShellScriptBin "tmux" (wrapcmd "${pkgs.tmux}/bin/tmux -f ${conf.tmux}"))
      ];
    };

    tree = let script = pkgs.writeShellScriptBin
      "tree"
      (wrapcmd "${pkgs.tree}/bin/tree --dirsfirst -AC --prune" );
    in
      pkgs.symlinkJoin { name = "tree-join"; paths = [ (pkgs.tree + /share) script ]; };
  };

  # technically, these are executables, but they're more in the context
  # of wrapping "pieces" of a package, not the whole thing.
  # i.e, all 'tmux' commands should have the config file associated with it,
  # but "als" (which is an alias for ls with flags) is a part of pkgs.coreutils,
  # and all behavior shouldn't be modified/wrapped.
  commands = {
    als = pkgs.writeShellScriptBin
      "als"
      (wrapcmd ''${pkgs.coreutils-full}/bin/ls --group-directories-first --human-readable --color -al'');

    git-ui = pkgs.writeShellScriptBin "git-ui" ''
      git status > /dev/null 2>&1
      if test $? -ne 0
      then
        echo "not a git repository, nothing to look at."
        exit 1
      fi
      ${bin.nvim}/bin/nvim +"Git" +"only"
    '';

    git-root = pkgs.writeShellScriptBin "git-root" ''
      ${pkgs.git}/bin/git rev-parse --show-toplevel
    '';

  };
in
  pkgs.buildEnv {
    name = "mainEnv";
    paths =
         (builtins.attrValues commands)
      ++ (builtins.attrValues bin)
      ++ (if builtins.currentSystem == "aarch64-darwin" then [] else [pkgs.bitwarden-cli])
      ++ (import ./packages/lsp.nix { pkgs = pkgs; })
      ++ [
          # version of rtorrent that doesn't break.
          (import ./packages/rtorrent.nix {})

          pkgs.ansifilter
          pkgs.code-minimap
          pkgs.coreutils-full
          pkgs.coursier
          pkgs.curl
          pkgs.ffmpeg
          pkgs.fd
          pkgs.fnlfmt
          pkgs.fzf
          pkgs.gettext
          pkgs.gh
          pkgs.git
          pkgs.glow
          pkgs.gnumake
          pkgs.gnused
          pkgs.gum
          pkgs.jq
          pkgs.lean
          pkgs.moar
          pkgs.neovim-remote
          pkgs.nodePackages_latest.pyright
          pkgs.pylint
          pkgs.python311Packages.sqlparse
          pkgs.readline
          pkgs.redis
          pkgs.rename
          pkgs.ripgrep
          pkgs.visidata
          pkgs.wget
          pkgs.yq
        ];
}
# broken packages.
# pkcs11helper
# luaformatter
# nvimpager
