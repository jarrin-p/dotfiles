{
  wrapcmd, # util.nix .wrapcmd
}:

# returns a function that can be used with callPackage,
# without the fear of name collisions from custom local packages.
{
  writeShellScriptBin,
  coreutils-full,
  nvim, # in practice, this should be the alias.nvim
  git
}:

  # technically, these are executables, but they're more in the context
  # of wrapping "pieces" of a package, not the whole thing.
  # i.e, all 'tmux' commands should have the config file associated with it,
  # but "als" (which is an alias for ls with flags) is a part of pkgs.coreutils,
  # and all behavior shouldn't be modified/wrapped.
  [
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
        ${nvim}/bin/nvim +"Git" +"only"
      '')

      (writeShellScriptBin "git-root" ''
        ${git}/bin/git rev-parse --show-toplevel
      '')
  ]
