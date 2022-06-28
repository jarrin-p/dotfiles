#!/bin/sh
echo 'the bug is just a warning when using this version of stow'
echo "running: 'stow -R managed -t ../../'"
stow -R managed -t ../../
echo 'restowed'
