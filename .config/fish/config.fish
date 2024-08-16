if ! status is-interactive
    exit 0
end

set fish_greeting "" # disable greeting.

# make fish more vi like.
fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block

function lf
  cd (command lf)
end

# explicitly state our terminal can support a changing cursor.
if string match -q 'xterm*' $TERM
    set -g fish_vi_force_cursor 1

    # hide text displaying cursor mode.
    function fish_mode_prompt
    end
end

set __fish_git_prompt_show_informative_status 1
function fish_prompt
    printf "\n"

    set -l git (fish_git_prompt)
    if ! test -z "$git"
        set_color blue
        fish_git_prompt | tr -d ' '
        printf ' '
    end

    set_color brblack
    set -l timestamp (date '+%T %a %b %d' | tr -d "\n")

    printf "$timestamp\n"

    set_color white
    if ! test -z "$SSH_CLIENT"
        set -l client (echo "$SSH_CLIENT" | awk -F' ' '{ printf $1 }')
        printf "[client: $client] "
    end
    printf $USER

    set -l disp (string join / (string split -- / $PWD)[-2..-1])
    set_color green
    printf " $disp "

    set_color yellow
    printf "> "
end

# aws completion
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
