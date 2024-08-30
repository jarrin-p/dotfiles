{
  # additional configuration (must be supplied by caller)
  callerPath,

  # the remaining are attributes of the nixpkgs set and will be
  # provided by `callPackage` if not given.

  # nixpkgs methods.
  buildEnv,
  callPackage,
  runCommand,
  symlinkJoin,
  writeShellScriptBin,

  # unmodified pkgs.
  ansifilter,
  code-minimap,
  coursier,
  curl,
  ffmpeg,
  fd,
  fnlfmt,
  fzf,
  gettext,
  gh,
  git,
  glow,
  gnumake,
  gnused,
  gum,
  jq,
  lean,
  moar,
  # python311Packages.sqlparse,
  readline,
  redis,
  rename,
  ripgrep,
  visidata,
  wget,
  yq,

  # wrapped pkgs
  bash,
  bat,
  bitwarden-cli,
  coreutils-full,
  direnv,
  fish,
  lf,
  nix-direnv,
  sd,
  tmux,
  tree,
}:
let

  setenv = ''
    export PAGER=${bin.bat}/bin/bat
    export MANPAGER="${bin.bat}/bin/bat --wrap never"
    export EDITOR=${bin.nvim}/bin/nvim
    export VISUAL=${bin.nvim}/bin/nvim
    export NIX_DIRENV_LOCATION="${nix-denv}"
    export DIRENV_BIN="${direnv}/bin/direnv"
    export FZF_DEFAULT_COMMAND="rg --glob '!*.git' --glob '!*.class' --glob '!*.jar' --glob '!*.java.html' --files --hidden"
    export NIX_USER_CONF_FILES=${conf.nixconf}
  '';

  # build the hacky export string.
  # direnv only supports passing configuration (direnvrc) through XDG_CONFIG_HOME/direnv/direnvrc,
  # this is pretty much an ugly hack to allow direnv to stay isolated in nix, by altering
  # the sourced hook function to include an export before the `direnv` binary is called.
  nix-denv = runCommand "nix-direnv-as-xdg" {} ''
      mkdir -p $out/direnv
      cp ${nix-direnv}/share/nix-direnv/direnvrc $out/direnv/direnvrc
  '';

  conf = {
    # want the helper tool to notice updates. if this were a path,
    # it would be stored in the nix-store, and thus would never look like
    # it changes.
    this = toString ./main-env.nix;

    fish = ../fish/config.fish;
    fishhook = ./packages/fish;
    lf_config_home = builtins.path { name = "lf_config_home"; path = ../../.config; };
    nixconf = ../nix/nix.conf;
    root = ../../../dotfiles;
    tmux = builtins.path { name = "tmux_config"; path = ../tmux/.tmux.conf; };
  };

  # helper for wrapping commands while preserving script input arguments.
  # `bash` automatically splits strings into lists, i.e. ./script "hello world" is
  # processed as a script with two arguments. this function works around that.
  wrapcmd = cmd: ''eval "${cmd} ''${*@Q}"'';

  bin = {
    bat = let
      wrapped = wrapcmd "${bat}/bin/bat";
      script = (writeShellScriptBin "bat" ''
        export BAT_THEME=TwoDark
        ${wrapped}
      '');
    in
      symlinkJoin { name = "bat-join"; paths = [ (bat + /share) script ]; };

    dots-script = (callPackage ./dots-script.nix { inherit callerPath; });

    # load env vars before loading fish shell.
    # this allows other shells to use them upon invocation as well, without having
    # to have a lot of duplicate rcs for the preferences.
    fish = let
      script = writeShellScriptBin "fish" ''
        ${setenv}
        ${fish}/bin/fish --init-command="source ${conf.fish} && source ${conf.fishhook}/direnv-hook.fish" $@
      '';
    in
      symlinkJoin { name = "fish-join"; paths = [ (fish + /share) script ]; };

    lf = let script = writeShellScriptBin "lf" ''
        export PATH=${lf}/bin:${coreutils-full}/bin:${bash}/bin
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
      symlinkJoin { name = "lf-join"; paths = [ (lf + /share) script ]; };

    nvim = (callPackage ./packages/nvim.nix {});

    # simple command for ensuring nvim can open.
    # eventually this should get moved into a test method when
    # building nvim.
    nvim-debug = writeShellScriptBin "nvim_d" ''
      ${bin.nvim}/bin/nvim --headless +q
    '';

    tmux = symlinkJoin {
      name = "tmux-join";
      paths = [
        (tmux + /share)
        (writeShellScriptBin "tmux" (wrapcmd "${tmux}/bin/tmux -f ${conf.tmux}"))
      ];
    };

    tree = let script = writeShellScriptBin
      "tree"
      (wrapcmd "${tree}/bin/tree --dirsfirst -AC --prune" );
    in
      symlinkJoin { name = "tree-join"; paths = [ (tree + /share) script ]; };
  };

  # technically, these are executables, but they're more in the context
  # of wrapping "pieces" of a package, not the whole thing.
  # i.e, all 'tmux' commands should have the config file associated with it,
  # but "als" (which is an alias for ls with flags) is a part of pkgs.coreutils,
  # and all behavior shouldn't be modified/wrapped.
  commands = [
    (writeShellScriptBin
      "als"
      (wrapcmd ''${coreutils-full}/bin/ls --group-directories-first --human-readable --color -al''))

    (writeShellScriptBin "git-ui" ''
      git status > /dev/null 2>&1
      if test $? -ne 0
      then
        echo "not a git repository, nothing to look at."
        exit 1
      fi
      ${bin.nvim}/bin/nvim +"Git" +"only"
    '')

    (writeShellScriptBin "git-root" ''
      ${git}/bin/git rev-parse --show-toplevel
    '')

  ];
in
  buildEnv {
    name = "dotx-environment";
    paths =
         (builtins.attrValues bin)
      ++ commands
      ++ (if builtins.currentSystem == "aarch64-darwin" then [] else [bitwarden-cli])
      ++ (callPackage ./packages/lsp.nix {})
      ++ [
          # version of rtorrent that isn't broken.
          (import ./packages/rtorrent.nix {})

          ansifilter
          code-minimap
          coreutils-full
          coursier
          curl
          direnv
          ffmpeg
          fd
          fnlfmt
          fzf
          gettext
          gh
          git
          glow
          gnumake
          gnused
          gum
          jq
          lean
          moar
          readline
          redis
          rename
          ripgrep
          sd
          visidata
          wget
          yq
        ];
}
# broken packages.
# pkcs11helper
# luaformatter
# nvimpager
