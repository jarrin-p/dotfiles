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
      setup_shell  add a shim to a shell that sources config accessors for used apps.
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

  setup_shell() {
      test -z "$1" || test -z "$2" && {
          echo "error. required arguments missing:"
          echo "\$1 = bash | zsh | fish"
          echo "\$2 = /path/to/dotx/config"
          exit 1
      }
      case "$1" in
          fish)
              mkdir -p $HOME/.config/fish/conf.d
              cat <<-EOF > $HOME/.config/fish/conf.d/dotx-config.fish
  set -x DOTX_CONFIG_LOCATION "$2"
  source \$DOTX_CONFIG_LOCATION/.config/fish/config.fish
  EOF
              ;;
          *)
              echo "unknown shell. aborting."
              exit 1
              ;;
      esac
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
          setup_shell)
              supported_shell=$(gum choose --header="shell to setup" "bash" "zsh" "fish")
              supported_path=$(gum input --header="path to location of dotfiles" --value="$(pwd)")
              setup_shell $supported_shell $supported_path
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
      choice=$(gum choose --ordered "install" "setup_shell" "uninstall" "usage" "cancel")
      handle $choice
  else
      while ! test -z "$1"
      do
          handle $1
          shift
      done
  fi
''
