source ~/.zshrc.private

# color ls
alias ls="ls -G"

function man { nvim -c "Man $1" -c "only" } # Use neovim's man command instead of gnu-man

# Quick Access
alias gittop='pushd $(git rev-parse --show-toplevel)'

# requires (n)vim `fugitive` plugin
alias g='nvim -c "wincmd l" -c "Git" -c "only"'

# enhanced ssh functionality using kitty
alias ssh='kitty +kitten ssh' 

# shorthands
alias dcu="docker compose up"
alias dcub="docker compose up --build"
function dcrun { docker compose run $1 } # Parameter is for the service name
alias set_intel="clear ; arch -x86_64 /bin/zsh ; echo $(arch)"

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
export FZF_DEFAULT_COMMAND='rg --glob "!*.git" --glob "!*.class" --glob "!*.jar" --glob "!*.java.html" --hidden --no-ignore --files'

# fix a color scheme issue i hated
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=bg+:-1
'

# see `dotfiles/get_antigen.sh`
source /usr/local/share/antigen.zsh

# add bundles
antigen bundle jeffreytse/zsh-vi-mode
antigen bundle rupa/z

# necessary after adding bundles
antigen apply

# vim: fdm=marker
