source ~/.zshrc.private

# Shell prompt
ZZ_DEFAULT_PROMPT=$PS1
function sp_default { export PS1="$ZZ_DEFAULT_PROMPT" }
function sp_level { export PS1="%n %${1}~ > " }

export JAVA_HOME=`/usr/libexec/java_home -v 11.0.13`

# Quick Access
alias zshrc="nvim $ZSHRC -c 'cd %:h'"
alias zshrcp="nvim $ZSHRCP -c 'cd %:h'"
alias nvimrc="nvim $NVIMRC -c 'cd %:h'"
alias skhdrc="nvim $SKHDCONF -c 'cd %:h'"
alias yabairc="nvim $YABAICONF -c 'cd %:h'"
alias kittyconf="nvim $KITTYCONF -c 'cd %:h'"

alias dcu="docker compose up"
alias dcub="docker compose up --build"
function dcrun { docker compose run $1 } # Parameter is for the service name

alias set_intel="clear ; arch -x86_64 /bin/zsh"

alias load_yabai="yabai & ; sudo yabai --load-sa ; ps -ax | grep yabai ; disown yabai ; skhd & ; disown skhd ; ps -ax | grep skhd ;"
alias stop_yabai="pkill yabai ; ps -ax | grep yabai ; pkill skhd ; ps -ax | grep skhd ;"

function man { nvim -c "Man $1" -c "only" } # Use neovim's man command instead of gnu-man

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
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

sp_level 1
# vim: fdm=marker
