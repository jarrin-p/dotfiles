source ~/.zshrc.private

alias ls="ls --color" # color ls
function man { nvim -c "Man $1" -c "only" } # Use neovim's man command instead of gnu-man
alias gittop='pushd $(git rev-parse --show-toplevel)' # Quick Access
alias g='nvim -c "wincmd l" -c "Git" -c "only"' # requires (n)vim `fugitive` plugin
alias ssh='kitty +kitten ssh' # enhanced ssh functionality using kitty
alias dcu="docker compose up"
alias dcub="docker compose up --build"
function dcrun { docker compose run $1 } # Parameter is for the service name

# git/vcs status info
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

# change fzf default to use ripgrep
export FZF_DEFAULT_COMMAND='rg --hidden --glob "!*.git" --glob "!*.class" --glob "!*.jar" --glob "!*.java.html" --no-ignore --files'

# fix a color scheme issue i hated
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=bg+:-1
'
if [ -d ~/.nix-profile/share ]; then
    {
        pushd ${HOME}/.nix-profile/share
        if [ -d zsh-z ]; then source ./zsh-z/zsh-z.plugin.zsh; fi
        if [ -d zsh-vi-mode ]; then source ./zsh-vi-mode/zsh-vi-mode.plugin.zsh; fi
        popd
    } &> /dev/null
fi

# open scrollback buffer in less
#alias sb='kitty @ launch --stdin-source=@screen_scrollback --stdin-add-formatting --type=overlay less +G -R'

# pipe a standard `psql` query into `visidata` as a `csv` for better viewing.
function query {
    QUERY=$1
    dvs -c "\copy ($QUERY) TO STDOUT CSV HEADER" | vd -f csv
}

function lquery {
    QUERY=$1
    lstack -c "\copy ($QUERY) TO STDOUT CSV HEADER" | vd -f csv
}
