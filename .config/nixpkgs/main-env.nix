{
  # configuration arguments.
  conf ? import ./paths.nix {},

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
  als,
  bash,
  bat,
  bitwarden-cli,
  coreutils-full,
  direnv,
  dots-script,
  fish,
  git-root,
  git-ui,
  lf,
  nix-direnv,
  nvim,
  nvim-debug,
  sd,
  tmux,
  tree,
}:
let

  setenv = ''
    export PAGER=${bat}/bin/bat
    export MANPAGER="${bat}/bin/bat --wrap never"
    export EDITOR=${nvim}/bin/nvim
    export VISUAL=${nvim}/bin/nvim
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



  };
in
  buildEnv {
    name = "dotx-environment";
    paths =
         (builtins.attrValues bin)
      ++ (if builtins.currentSystem == "aarch64-darwin" then [] else [bitwarden-cli])
      ++ (callPackage ./packages/lsp.nix {})
      ++ [
          # version of rtorrent that isn't broken.
          (import ./packages/rtorrent.nix {})

          als
          ansifilter
          bat
          code-minimap
          coreutils-full
          coursier
          curl
          direnv
          dots-script
          elan
          ffmpeg
          fd
          fnlfmt
          fzf
          gettext
          gh
          git
          git-ui
          git-root
          glow
          gnumake
          gnused
          gum
          jq
          luaformatter
          moar
          nvim
          nvim-debug
          readline
          redis
          rename
          ripgrep
          sd
          tmux
          tree
          visidata
          wget
          yq
        ];
}
# broken packages.
# pkcs11helper
# luaformatter
# nvimpager
