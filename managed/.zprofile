# @see .zshrc -> neovide conditional.
if [ ! -z $PRESERVE_PATH ]; then
    export PATH=$PRESERVE_PATH
fi

# >>> coursier install directory >>>
export PATH="$PATH:/Users/js/Library/Application Support/Coursier/bin"
# <<< coursier install directory <<<
