if status is-interactive

    # make fish more vi like.
    fish_vi_key_bindings
 
    # disable greeting.
    set fish_greeting ""

    # disable mode specification (uses cursor instead).
    function fish_mode_prompt
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
        printf $USER

        set -l disp (string join / (string split -- / $PWD)[-2..-1])
        set_color green
        printf " $disp "

        set_color yellow
        printf "> "
    end

    # fix wrongly ordered variables.
    fish_add_path $HOME/.nix-profile/bin
    fish_add_path /nix/var/nix/profiles/default/bin

    # load private files.
    if test -f $HOME/.fish.private
        source $HOME/.fish.private
    end

    # function nvim
    #     if test -n $TMUX
    #         echo (tmux display-message -p '#W')
    #         set -x NVIM_LISTEN_ADDRESS '/tmp/'(tmux display-message -p '#W')
    #         nvr -s $argv
    #     else
    #         echo 'tmux is empty'
    #         nvr -s $argv
    #     end
    # end

    function ls
        command ls --group-directories-first --color $argv
    end

    abbr --add gt pushd \(git rev-parse --show-toplevel\)
    abbr --add GT pushd \(git rev-parse --show-toplevel\)

    function get_repo_root
        git rev-parse --show-toplevel
    end

    function g --description "Directly opens `Fugitive` in `nvim`."
        nvim -c "Git" -c "only"
    end

    function tree
        command tree --dirsfirst -AC --prune $argv
    end

    # wip
    function here
        set -l matched (string replace (get_repo_root) '' (pwd))
        echo $matched
        tree -P $matched --matchdirs (get_repo_root)
    end

    function nix-fish --description "start nix-shell using fish instead. "
        nix-shell --command "fish" $argv
    end

    function todo
        if test -f $HOME/Info
            mkdir $HOME/Info
            cd $HOME/Info
            touch todo.md
        end

        nvim $HOME/Info/todo.md
    end

    function vcd
        cd (cat $VIM_CWD_PATH)
    end

    function lf
        set -x LF_CD_FILE /tmp/.lfcd
        command lf $argv
        set -l dir (realpath (cat $LF_CD_FILE))
        if test -s $LF_CD_FILE && test "$dir" != "$(pwd)"
            cd "$dir"
        end
        rm $LF_CD_FILE
        set -u LF_CD_FILE
    end

    # aws completion
    complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

    direnv hook fish | source

    # explicitly state our terminal can support a changing cursor.
    if status is-interactive
        if string match -q 'xterm*' $TERM
            set -g fish_vi_force_cursor 1
        end
    end

    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_visual block

    set -x PAGER moar
    set -x EDITOR nvim
    set -x VISUAL nvim
    #set -x SHELL fish

    function clean_scala
        find . -name '.bsp' | xargs -I% rm -rf %
        find . -name '.metals' | xargs -I% rm -rf %
        find . -name '.bloop' | xargs -I% rm -rf %
    end

    function grab -a file --description "stores a realpath of a file, which can then be retrieved by executing the fn put."
        set -l p (realpath $file)
        realpath $file > /tmp/.config/grab
        echo "stored $p"
    end

    function put --description "retrieves the path stored by grab."
        cat /tmp/.config/grab
    end

    mkdir -p /tmp/.config
    set -x FZF_DEFAULT_COMMAND "rg --glob '!*.git' --glob '!*.class' --glob '!*.jar' --glob '!*.java.html' --files --hidden"

    set -x _BOOKMARKS /tmp/.config/bookmarks
    function marks
        argparse 'a/add=' 'e/edit' -- $argv

        ! test -z "$_flag_edit" && nvim $_BOOKMARKS && return
        ! test -z "$_flag_add" && add_mark $_flag_add && return

        cat $_BOOKMARKS | gum choose
    end

    function add_mark -a mark
        echo $mark >> $_BOOKMARKS
        set -l _marks (cat $_BOOKMARKS | sort -u)
        rm $_BOOKMARKS
        for _mark in $_marks
            echo $_mark >> $_BOOKMARKS
        end
    end
end

