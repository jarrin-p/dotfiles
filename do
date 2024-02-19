#!/bin/sh

usage() {
    cat <<-EOF
    usage
    ./do [command]

    command:
        refresh    re-runs nix install
        setup      sets up the environment for the first time
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

while ! test -z "$1"
do
    case "$1" in
        s*)
            install_pkgs
            restow
            ;;
        r*)
            install_pkgs
            ;;
        u*)
            unstow
            nix-env --uninstall 'mainEnv'
            ;;
        *)
            usage
            ;;
    esac
    shift
done
