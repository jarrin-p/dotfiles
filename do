#!/bin/sh

command -v gum > /dev/null
has_gum=$?

usage() {
    cat <<-EOF
    usage
    ./do [command]

    command:
        usage      shows this.
        refresh    re-runs nix install.
        setup      sets up the environment for the first time.
        uninstall  removes everything.
EOF
}

install_pkgs() {
    if test -f .config/nixpkgs/main-env.nix
    then
        echo 'installing .config/nixpkgs/main-env.nix'
        nix-env -if .config/nixpkgs/main-env.nix
    else
        echo 'could not locate main file. try running from the root of this repo.'
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
            cat <<-EOF > $HOME/.config/fish/conf.d/dotx-config.fish
set -x DOTX_CONFIG_LOCATION "$2"
source \$DOTX_CONFIG_LOCATION/fish/config.fish
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
        refresh)
            install_pkgs
            ;;
        setup_shell)
            supported_shell=$(gum choose "bash" "zsh" "fish")
            supported_path=$(gum input)
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

if test -z "$@" && test $has_gum -eq 0
then
    choice=$(gum choose --ordered "refresh" "setup" "stow" "uninstall" "usage" "cancel")
    handle $choice
elif test -z "$@"
then
    usage
else
    while ! test -z "$1"
    do
        handle $1
        shift
    done
fi
