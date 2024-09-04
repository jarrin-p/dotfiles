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

      refresh, r
        runs 'nix-env -if <path/to/main-env.nix>'. 

      uninstall
        removes everything.

      help, usage
        shows this.
  EOF
  }

  refresh_pkgs() {
      if test -f ${callerPath}
      then
          echo 'installing ${callerPath}.'
          echo 'steps:'
          echo "  nix profile remove 'dotx-environment'"
          echo "  try   -> nix profile install"
          echo "  catch -> nix profile rollback"
          echo ""
          nix profile remove 'dotx-environment' \
            && {
              if test "$1" = "--verbose"
              then
                echo '[verbose] installing profile.'
                nix profile install --print-build-logs --file ${callerPath}
              else
                echo 'installing profile.'
                nix profile install --file ${callerPath}
              fi
            } || {
              echo 'failed to install. rolling back.'
              nix profile rollback
            }
      else
          echo 'could not locate main file. maybe you moved the repository?'
          echo 'if so, remove then install from the new directory to get this script working again.'
      fi
  }

  handle() {
      case "$1" in
          refresh)
              refresh_pkgs $2
              ;;
          r)
              refresh_pkgs $2
              ;;
          dir)
              dirname ${callerPath}
              ;;
          uninstall)
              nix profile remove 'dotx-environment'
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
      handle "$1" "$2"
      shift
  fi
''
