# fix a color scheme issue i hated
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=bg+:-1
'

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
    echo " "
    [ ! -z $IN_NIX_SHELL ] && echo '[nix-shell]'
}
PS1='${vcs_info_msg_0_}%f%n %2~ %F{4}> %f'

ZZ_DEFAULT_PROMPT=$PS1
function sp_default { export PS1="$ZZ_DEFAULT_PROMPT" }
function sp_level { export PS1="%n %${1}~ > " }

# vi mode cursors.
cursor_block="\033[2 q"
cursor_thin="\033[6 q"

# special zle functions.
zle-line-init () {
    zle -K viins # starts new shell with insert mode active.
    printf $cursor_thin
}
zle-keymap-select () {
    case $KEYMAP in
        vicmd) printf $cursor_block ;;
        *) printf $cursor_thin ;;
    esac
}

# set zle widgets.
zle -N zle-keymap-select
zle -N zle-line-init
bindkey -v

eval "$(direnv hook zsh)"
