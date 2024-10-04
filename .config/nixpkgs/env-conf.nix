# I don't really like this file, it's some weird cross breed of
# having global configuration, having callPackage dependencies for
# determining values of configuration, and depending on custom
# implementations in the same file.
#
# I need to either break up the aliases even further into their own files,
# to allow more flexible importing.
#
# Honestly, I think I should consider abandoning 'alias.nix' and 'commands.nix'
# in favor of individual files for each. It would remove having to focus on
# "what kind of package is this and where does it occur."
{
  paths, # paths.nix
}:

# returns function with pinned configuration for callPackage.
{
  runCommand,
  jq,
  direnv,
  nix-direnv,
}:

{ nvim, bat }:

let
  # build the hacky export string.
  # direnv only supports passing configuration (direnvrc) through XDG_CONFIG_HOME/direnv/direnvrc,
  # this is pretty much an ugly hack to allow direnv to stay isolated in nix, by altering
  # the sourced hook function to include an export before the `direnv` binary is called.
  nix-denv = runCommand "nix-direnv-as-xdg" {} ''
      mkdir -p $out/direnv
      cp ${nix-direnv}/share/nix-direnv/direnvrc $out/direnv/direnvrc
  '';
in
  ''
    export PAGER=${bat}/bin/bat
    export MANPAGER="${bat}/bin/bat --wrap never"
    export EDITOR=${nvim}/bin/nvim
    export VISUAL=${nvim}/bin/nvim
    export NIX_DIRENV_LOCATION="${nix-denv}"
    export DIRENV_BIN="${direnv}/bin/direnv"
    export FZF_DEFAULT_COMMAND="rg --glob '!*.git' --glob '!*.class' --glob '!*.jar' --glob '!*.java.html' --files --hidden"
    export PATH=$HOME/.elan/bin:$PATH

    # array separated by newlines.
    export COLORS_PATH=${paths.colors}
    export COLORS=$(${jq}/bin/jq -r '.color[]' ${paths.colors})
  ''
