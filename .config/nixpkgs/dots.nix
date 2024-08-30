{ writeShellScriptBin, coreutils-full, gum, callerPath }:
writeShellScriptBin "dots" ''
  export PATH=$PATH:${gum}/bin:${coreutils-full}/bin

  usage() {
      cat <<-EOF
  usage
      dots # using without a command will open a command chooser.
      dots [command]

  commands
      dir
        show the directory where the dotfiles are located.

      install, refresh, r
        runs 'nix-env -if <path/to/main-env.nix>'. 

      uninstall
        removes everything.

      help, usage
        shows this.
  EOF
  }

  install_pkgs() {
      if test -f ${callerPath}
      then
          echo 'installing ${callerPath}'
          nix-env -if ${callerPath}
      else
          echo 'could not locate main file. maybe you moved this directory? if so, reinstall without this tool.'
      fi
  }

  handle() {
      case "$1" in
          install)
              install_pkgs
              ;;
          refresh)
              install_pkgs
              ;;
          r)
              install_pkgs
              ;;
          dir)
              dirname ${callerPath}
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
      choice=$(gum choose --ordered "install" "refresh" "uninstall" "usage" "cancel")
      handle $choice
  else
      while ! test -z "$1"
      do
          handle $1
          shift
      done
  fi
''
