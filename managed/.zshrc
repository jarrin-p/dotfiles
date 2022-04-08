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
alias gittop='pushd $(git rev-parse --show-toplevel)'
alias g='nvim -c "Git" -c "only"'

alias dcu="docker compose up"
alias dcub="docker compose up --build"
function dcrun { docker compose run $1 } # Parameter is for the service name

alias set_intel="clear ; arch -x86_64 /bin/zsh ; echo $(arch)"

alias load_yabai="yabai & ; sudo yabai --load-sa ; ps -ax | grep yabai ; disown yabai ; skhd & ; disown skhd ; ps -ax | grep skhd ;"
alias stop_yabai="pkill yabai ; ps -ax | grep yabai ; pkill skhd ; ps -ax | grep skhd ;"

function man { nvim -c "Man $1" -c "only" } # Use neovim's man command instead of gnu-man

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

# change fzf default to use ripgrep
export FZF_DEFAULT_COMMAND='rg --glob !.git --hidden --no-ignore --files'

# shell mods
source /usr/local/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
. /usr/local/etc/profile.d/z.sh

#sp_level 1
# vim: fdm=marker