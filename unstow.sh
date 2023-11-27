#!/bin/sh

cd ..
if ! test -d dotfiles
then
	echo 'could not find repo to use as package. aborting.'
	exit 1
fi

dots=$(pwd)
relpath=$(python -c "import os.path; print(os.path.relpath('$HOME', '$dots'))") || exit 1

echo "undoing stow using $relpath/"
stow -D dotfiles -t $relpath/

echo 'stow undone.'
