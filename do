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
        nix-env -if .config/nixpkgs/main-env.nix
    else
        echo 'could not locate main file. try running from the root of this repo.'
    fi
}

check_dots() {
    if ! test -d dotfiles
    then
        echo 'could not find repo to use as package. aborting.'
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

case "$1" in
    setup*)
        install_pkgs
        restow
        ;;
    refr*)
        echo 'refreshing "main-env.nix"'
        install_pkgs
        ;;
    uninst*)
        unstow
        nix-env --uninstall 'mainEnv'
        ;;
    *)
        usage
        ;;
esac
