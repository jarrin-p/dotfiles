source ~/.zshrc.private

function source_if_exists () {
    [ -f "${1}" ] && source "${1}"
}
# source_if_exists "${HOME}/.nix-profile/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source_if_exists "${HOME}/.nix-profile/share/zsh-z/zsh-z.plugin.zsh"
source_if_exists "${HOME}/.fzf.zsh"

# if neovide is present, change the `nvim` command to open it instead.
if [ -f "/Applications/Neovide.app/Contents/MacOS/neovide" ]; then
    export PATH="/Applications/Neovide.app/Contents/MacOS:${PATH}"

    # neovide runs as a login shell. this re-sources /etc/zprofile, which prepends directories to the path (like `/usr/bin ... etc`)
    # on a mac, `/etc/libexec/path_helper`  changes the order of priority by removing duplicates from the end of the path.
    # example: (start) PATH=A:B -> (resource zprofile) PATH=B:A:B -> (path_helper runs because login shell) PATH=B:A.
    # so if A/foo and B/foo, the resource now gives B/foo priority.

    # note that there is a `.zprofile` to handle `PRESERVE_PATH` since interactive shells do not source the `.zshrc` (and it wouldn't matter anyway...).
    # this is just a hack to get it working, e.g. pyright is looking at the wrong python executable in neovide-nvim for the lsp.
    function nvim () {
        (
            export PRESERVE_PATH=$PATH
            neovide --multigrid -- $@
        )
    }
fi

# general
function ls () { $HOME/.nix-profile/bin/ls --color $@ } # default to color ls.

# nix
function nix-zsh () { nix-shell --command "zsh" $@ } # start nix-shell using zsh instead.
function mainEnv () { nix-env -iA nixpkgs.mainEnv } # (re)install main config.

# kitty
function ssh () { kitty +kitten ssh } # enhanced ssh functionality using kitty.

# docker
function dcu () { docker compose up }
function dcub () { docker compose up --build }
function dcrun () { docker compose run $@ }

# git
function g () { nvim -c "Git" -c "only" } # requires (n)vim `fugitive` plugin
function gs () { git stash }
function gsp () { git stash pop }
function gt { pushd $(git rev-parse --show-toplevel) } # goto root of git directory.
function GT { pushd $(git rev-parse --show-toplevel) }

# sets the open neovim session's current directory to the current directory of the shell.
# @see `neovim-remote`
function here () { nvr +"cd $PWD" }

# clones todo repo if file doesn't exist.
function todo () {
    if [ ! -d "${HOME}/Info" ]; then (
        cd ${HOME}
        mkdir -p "${HOME}/Info"
        touch "${HOME}/Info/todo.md"
    ) fi
    nvim ${HOME}/Info/todo.md
}

# change fzf default to use ripgrep
export FZF_DEFAULT_COMMAND='rg --hidden --glob "!*.git" --glob "!*.class" --glob "!*.jar" --glob "!*.java.html" --no-ignore --files'
function fzfd () {
    find . -type d | fzf
}

# fix a color scheme issue i hated
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=bg+:-1
'

# pipe a standard `psql` query into `visidata` as a `csv` for better viewing.
function query {
    QUERY=$1
    dvs -c "\copy ($QUERY) TO STDOUT CSV HEADER" | vd -f csv
}

# when switching branches sometimes jdtls gets confused, cleaning quickly remedies this.
function clean_jdtls {
    find . -name ".project" -or -name ".settings" | xargs rm -rf
}

# prompt config
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git cvs svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%f[%F{6}staged changes%f] "
zstyle ':vcs_info:*' unstagedstr "%f[%F{11}unstaged changes%f] "

zstyle ':vcs_info:*' actionformats \
  '%F{7}%r.%s %f[%F{4}%b|%a%f] %c%u
'
zstyle ':vcs_info:*' formats       \
  '%F{7}%r.%s %f[%F{4}%b%f] %c%u
'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r
'
# add new line after each command
precmd () {
    vcs_info
    echo ""
    [ ! -z $IN_NIX_SHELL ] && echo '[nix-shell]'
}
PS1='${vcs_info_msg_0_}%f%n %2~ %F{4}> %f'

ZZ_DEFAULT_PROMPT=$PS1
function sp_default { export PS1="$ZZ_DEFAULT_PROMPT" }
function sp_level { export PS1="%n %${1}~ > " }

# easier to use emacs mode in vim emulated terminal.
set -o emacs

# vim: ft=bash fdm=manual foldlevel=0
