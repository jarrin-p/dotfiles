source ~/.zshrc.private

#alias ls="ls --color=auto"
alias ls="ls -G"

# Quick Access
alias zshrc="nvim $ZSHRC -c 'cd %:h'"
alias zshrcp="nvim $ZSHRCP -c 'cd %:h'"
alias nvimrc="nvim $NVIMRC -c 'cd %:h'"
alias skhdrc="nvim $SKHDCONF -c 'cd %:h'"
alias yabairc="nvim $YABAICONF -c 'cd %:h'"
alias kittyconf="nvim $KITTYCONF -c 'cd %:h'"

alias sed="gsed"
alias dcu="docker compose up"
alias dcub="docker compose up --build"
function dcrun { docker compose run $1 } # Parameter is for the service name

alias set_intel="clear ; arch -x86_64 /bin/zsh ; echo $(arch)"

alias load_yabai="yabai & ; sudo yabai --load-sa ; ps -ax | grep yabai ; disown yabai ; skhd & ; disown skhd ; ps -ax | grep skhd ;"
alias stop_yabai="pkill yabai ; ps -ax | grep yabai ; pkill skhd ; ps -ax | grep skhd ;"

function man { nvim -c "Man $1" -c "only" } # Use neovim's man command instead of gnu-man

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# quickly open a mac .app from a variety of locations
# used with yabai + skhd to behave like spotlight but for apps
# in locations I specify (spotlight wasn't picking up all of them)
function app {
	find /Applications -depth 1 -maxdepth 1 -name "*.app" 2>/dev/null > /tmp/appnames
	find /System/Applications -depth 1 -maxdepth 1 -name "*.app" 2>/dev/null >> /tmp/appnames
    find /System/Applications/Utilities -depth 1 -maxdepth 1 -name "*.app" 2>/dev/null >> tmp/appnames
	open "$(cat /tmp/appnames | fzf -e)"
	rm /tmp/appnames
}

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

precmd () { 
    vcs_info 
    echo ""
}
PS1='${vcs_info_msg_0_}%f%n %2~ %F{4}> %f'

ZZ_DEFAULT_PROMPT=$PS1
function sp_default { export PS1="$ZZ_DEFAULT_PROMPT" }
function sp_level { export PS1="%n %${1}~ > " }

#sp_level 1
# vim: fdm=marker
