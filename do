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
        stow       applies stow for changes that might need... stowing.
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

check_dots() {
    echo 'checking for dotfiles to use as package.'
    if ! test -d dotfiles
    then
        echo 'ERROR: could not find repo to use as package. aborting.'
        exit 1
    fi
}

restow() {
    cd ..

    check_dots
    dots=$(pwd)
    relpath=$(python -c "import os.path; print(os.path.relpath('$HOME', '$dots'))") || exit 1

    echo "stowing using $relpath/"
    stow -R dotfiles -t $relpath/ > /dev/null

    echo 'restowed'
}

unstow() {
  cd ..

  check_dots
  dots=$(pwd)

  relpath=$(python -c "import os.path; print(os.path.relpath('$HOME', '$dots'))") || exit 1

  echo "undoing stow using $relpath/"
  stow -D dotfiles -t $relpath/

  echo 'stow undone.'
}

handle() {
    case "$1" in
        refresh)
            install_pkgs
            ;;
        setup)
            install_pkgs
            restow
            ;;
        stow)
            restow
            ;;
        uninstall)
            unstow
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
