# TODO: revisit notes in env-conf.nix
{
  callerPath, # required, convenience string for re-installing the calling nix file.

  wrapcmd,
  paths,
}:

# note that this is returning a function that can be used with callPackage,
# it should be imported first with configuration files specified first.
{
  symlinkJoin,
  writeShellScriptBin,
  bash,
  bat,
  fish,
  lf,
  tmux,
  tree,
  coreutils-full,
  callPackage,
}:

let
  setenv = callPackage (import ./env-conf.nix { inherit paths; }) {};
in

# everything in here will get automatically brought into the env.
# everything is also named, because it may be used elsewhere.
rec {
    bat-bin = let
      wrapped = wrapcmd "${bat}/bin/bat";
      script = (writeShellScriptBin "bat" ''
        export BAT_THEME=TwoDark
        ${wrapped}
      '');
    in
      symlinkJoin { name = "bat-join"; paths = [ (bat + /share) script ]; };

    dots-script = (callPackage ./dots-script.nix { inherit (paths) colors; inherit callerPath; });

    # load env vars before loading fish shell.
    # this allows other shells to use them upon invocation as well, without having
    # to have a lot of duplicate rcs for the preferences.
    fish-bin = let
      script = writeShellScriptBin "fish" ''
        ${setenv {inherit nvim; bat = bat-bin; }}
        ${fish}/bin/fish --init-command="source ${paths.fish} && source ${paths.fishhook}/direnv-hook.fish" $@
      '';
    in
      symlinkJoin { name = "fish-join"; paths = [ (fish + /share) script ]; };

    lf-bin = let script = writeShellScriptBin "lf" ''
        export PATH=${lf}/bin:${coreutils-full}/bin:${bash}/bin
        export LF_CONFIG_HOME=${paths.lf_config_home};
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
    nvim-debug = let wrapped = wrapcmd "${nvim}/bin/nvim --headless"; in
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
        (writeShellScriptBin "tmux" (wrapcmd "${tmux}/bin/tmux -f ${paths.tmux}"))
      ];
    };

    tree = let script = writeShellScriptBin
      "tree"
      (wrapcmd "${tree}/bin/tree --dirsfirst -AC --prune" );
    in
      symlinkJoin { name = "tree-join"; paths = [ (tree + /share) script ]; };
  }
