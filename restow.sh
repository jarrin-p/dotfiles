#!/bin/sh

cd ..
if ! test -d dotfiles
then
	echo 'could not find repo to use as package. aborting.'
	exit 1
fi

dots=$(pwd)
relpath=$(python -c "import os.path; print(os.path.relpath('$HOME', '$dots'))") || exit 1

echo "stowing using $relpath/"
stow -R dotfiles -t $relpath/ > /dev/null

echo 'restowed'
