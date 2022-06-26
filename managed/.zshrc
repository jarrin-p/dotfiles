source ~/.zshrc.private

# conditional loading (should happen first) {{{
function source_if_exists () {
    [ -f "${1}" ] && source "${1}"
}
source_if_exists "${HOME}/.nix-profile/share/zsh-z/zsh-z.plugin.zsh"
source_if_exists "${HOME}/.nix-profile/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source_if_exists "${HOME}/.jabba/jabba.sh"
source_if_exists "${HOME}/.fzf.zsh"

if [ -f "/Applications/Neovide.app/Contents/MacOS/neovide" ]; then
    export PATH="/Applications/Neovide.app/Contents/MacOS:${PATH}"
    alias nvim="neovide --multigrid --"
fi
# end conditional loading }}}

# shorthands, alias, etc {{{
alias ls='ls --color' # color ls
function man { nvim -c "Man $1" -c "only" } # Use neovim's man command instead of gnu-man
function GT { pushd $(git rev-parse --show-toplevel) } # Quick Access
alias g='nvim -c "Git" -c "only"' # requires (n)vim `fugitive` plugin
# alias todo="nvim ${HOME}/Documents/todo.md -c 'cd %:h'"
function todo() {
    # if the directory doesn't exist clone the repo
    if [ ! -d "${HOME}/Info" ]; then (
        cd ${HOME}
        mkdir -p "${HOME}/Info"
        touch "${HOME}/Info/todo.md"
    ) fi
    nvim ${HOME}/Info/todo.md -c 'lcd %:h'
}
alias ssh='kitty +kitten ssh' # enhanced ssh functionality using kitty
alias dcu='docker compose up'
alias dcub='docker compose up --build'
function dcrun { docker compose run $1 } # Parameter is for the service name
# end shorthands }}}

# environment variables exports {{{
# change fzf default to use ripgrep
export FZF_DEFAULT_COMMAND='rg --hidden --glob "!*.git" --glob "!*.class" --glob "!*.jar" --glob "!*.java.html" --no-ignore --files'

# fix a color scheme issue i hated
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=bg+:-1
'
# end environment variables }}}

# functions {{{

# open scrollback buffer in `less`. needs some cleanup.
function sb {
    kitty @ launch --stdin-source=@screen_scrollback --stdin-add-formatting --type=overlay less +G -R
}

# pipe a standard `psql` query into `visidata` as a `csv` for better viewing.
function query {
    QUERY=$1
    dvs -c "\copy ($QUERY) TO STDOUT CSV HEADER" | vd -f csv
}
function lquery {
    QUERY=$1
    lstack -c "\copy ($QUERY) TO STDOUT CSV HEADER" | vd -f csv
}

# finds filename at current directory.
function fd {
    FNAME=$1
    find . -name "${FNAME}"
}

function clean_jdtls {
    find . -name ".project" -or -name ".settings" | xargs rm -rf
}
# end functions }}}

# prompt config {{{
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
}
PS1='${vcs_info_msg_0_}%f%n %2~ %F{4}> %f'

ZZ_DEFAULT_PROMPT=$PS1
function sp_default { export PS1="$ZZ_DEFAULT_PROMPT" }
function sp_level { export PS1="%n %${1}~ > " }
# end prompt config }}}

# vim: ft=bash fdm=marker foldlevel=0
