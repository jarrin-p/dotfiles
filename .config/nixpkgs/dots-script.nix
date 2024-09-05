{ writeShellScriptBin, coreutils-full, gum, callerPath, colors }:
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

  colorscheme() {
    echo "exporting colorscheme as xresources"
    echo "note: this is based on the nix store version, not from ${callerPath}."
    echo "      you will need to re-install the profile to see changes made to the"
    echo "      colorscheme reflected here."
    echo ""
    jq -r '.color | to_entries | .[] | "*.color" + (.key | tostring) + ": " + .value' ${colors}
    jq -r '"*.foreground: " + .foreground' ${colors}
    jq -r '"*.background: " + .background' ${colors}
  }

  handle() {
      case "$1" in
          colorscheme)
              colorscheme
              ;;
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
      choice=$(gum choose --ordered "refresh" "colorscheme" "uninstall" "usage" "cancel")
      handle $choice
  else
      handle "$1" "$2"
      shift
  fi
''
