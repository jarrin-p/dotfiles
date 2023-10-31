#!/bin/sh
echo 'the bug is just a warning when using this version of stow'
echo "running: 'stow -R managed -t ../../'"
cd ..
stow -R dotfiles -t ../
echo 'restowed'
