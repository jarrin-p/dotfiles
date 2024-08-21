{ writeShellScriptBin, coreutils-full, gum, configLocation }:
writeShellScriptBin "dots" ''
  export PATH=$PATH:${gum}/bin:${coreutils-full}/bin

  usage() {
      cat <<-EOF
  usage
  ./dots [command]

  command:
      dir          show the directory where the dotfiles are located.
      install      runs nix install for the main environment.
      refresh      alias for install, but more natural when updating.
      uninstall    removes everything.
      usage        shows this.
  EOF
  }

  dir() {
    dirname ${configLocation}
  }

  install_pkgs() {
      if test -f ${configLocation}
      then
          echo 'installing ${configLocation}'
          nix-env -if ${configLocation}
      else
          echo 'could not locate main file. maybe you moved this directory? if so, reinstall without this tool.'
      fi
  }

  handle() {
      case "$1" in
          install)
              install_pkgs
              ;;
          go)
              ;;
          refresh)
              install_pkgs
              ;;
          uninstall)
              nix-env --uninstall 'mainEnv'
              ;;
          *)
              usage
              ;;
      esac
  }

  if test -z "$@"
  then
      choice=$(gum choose --ordered "install" "uninstall" "usage" "cancel")
      handle $choice
  else
      while ! test -z "$1"
      do
          handle $1
          shift
      done
  fi
''
