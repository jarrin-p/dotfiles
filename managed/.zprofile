# @see .zshrc -> neovide conditional.
if [ ! -z $PRESERVE_PATH ]; then
    export PATH=$PRESERVE_PATH
fi
