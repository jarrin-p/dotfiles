if ! status is-interactive
    exit 0
end

set fish_greeting "" # disable greeting.
echo "I did get sourced."

# make fish more vi like.
fish_vi_key_bindings
set -U fish_cursor_default block
set -U fish_cursor_insert line
set -U fish_cursor_replace_one underscore
set -U fish_cursor_visual block

set -U fish_color_normal normal
set -U fish_color_command green
set -U fish_color_quote yellow
set -U fish_color_redirection cyan --bold
set -U fish_color_end green
set -U fish_color_error brred
set -U fish_color_param cyan
set -U fish_color_comment red
set -U fish_color_match --background=brblue
set -U fish_color_selection white --bold --background=brblack
set -U fish_color_search_match bryellow --background=brblack
set -U fish_color_history_current --bold
set -U fish_color_operator brcyan
set -U fish_color_escape brcyan
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion brblack
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_cancel --reverse
set -U fish_pager_color_prefix normal --bold --underline
set -U fish_pager_color_progress brwhite --background=cyan
set -U fish_pager_color_completion normal
set -U fish_pager_color_description yellow --italics
set -U fish_pager_color_selected_background --reverse
set -U fish_pager_color_selected_description
set -U fish_pager_color_background
set -U fish_pager_color_selected_prefix
set -U fish_color_option
set -U fish_pager_color_secondary_completion
set -U fish_pager_color_secondary_background
set -U fish_pager_color_secondary_prefix
set -U fish_pager_color_secondary_description
set -U fish_color_keyword
set -U fish_pager_color_selected_completion
set -U fish_color_host_remote

function lf
  cd (command lf)
end

# explicitly state our terminal can support a changing cursor.
if string match -q 'xterm*' $TERM
    set -U fish_vi_force_cursor 1

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
# complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
