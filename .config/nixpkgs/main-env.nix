{
  # configuration arguments.
  callerPath, # required
  conf ? import ./paths.nix {},
  wrapcmd ? (import ./util.nix).wrapcmd,

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
  elan,
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
  luaformatter,
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
    export PAGER=${bat}/bin/bat
    export MANPAGER="${bat}/bin/bat --wrap never"
    export EDITOR=${bin.nvim}/bin/nvim
    export VISUAL=${bin.nvim}/bin/nvim
    export NIX_DIRENV_LOCATION="${nix-denv}"
    export DIRENV_BIN="${direnv}/bin/direnv"
    export FZF_DEFAULT_COMMAND="rg --glob '!*.git' --glob '!*.class' --glob '!*.jar' --glob '!*.java.html' --files --hidden"
    export NIX_USER_CONF_FILES=${conf.nixconf}
    export PATH=$HOME/.elan/bin:$PATH

    # array separated by newlines.
    export COLORS_PATH=${conf.colors}
    export COLORS=$(${jq}/bin/jq -r '.color[]' ${conf.colors})
  '';

  # build the hacky export string.
  # direnv only supports passing configuration (direnvrc) through XDG_CONFIG_HOME/direnv/direnvrc,
  # this is pretty much an ugly hack to allow direnv to stay isolated in nix, by altering
  # the sourced hook function to include an export before the `direnv` binary is called.
  nix-denv = runCommand "nix-direnv-as-xdg" {} ''
      mkdir -p $out/direnv
      cp ${nix-direnv}/share/nix-direnv/direnvrc $out/direnv/direnvrc
  '';

  bin = {
    dots-script = (callPackage ./dots-script.nix { inherit (conf) colors; inherit callerPath; });

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
    nvim-debug = let wrapped = wrapcmd "${bin.nvim}/bin/nvim --headless"; in
      writeShellScriptBin "nvim_d" ''
        if test "$1" = "--help"
        then
            echo 'runs nvim and prints any messages to stdout.'
            echo 'additional arguments/commands can be passed for specific testing.'
            echo 'runs: nvim --headless $@ +q'
            exit 0
        fi
        ${wrapped} +q
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
          bat
          code-minimap
          coreutils-full
          coursier
          curl
          direnv
          elan
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
          luaformatter
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
