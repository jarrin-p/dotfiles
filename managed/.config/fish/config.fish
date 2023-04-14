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

        set_color blue
        printf (fish_git_prompt)
        printf "\n"
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
    if test -f $HOME/.fish.private; source $HOME/.fish.private; end

    function ls
        command ls --group-directories-first --color $argv
    end

    function gt
        pushd $(git rev-parse --show-toplevel)
    end

    function GT
        pushd $(git rev-parse --show-toplevel)
    end

    function get_repo_root
        git rev-parse --show-toplevel
    end

    function g --description "Directly opens `Fugitive` in `nvim`."
        nvim -c "Git" -c "only"
    end

    function mainEnv --description "Updates current working environment."
        nix-env -iA nixpkgs.mainEnv
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

    # update ranger function to cd into the directory it currently landed on.
    function ranger --description "Opens `ranger` and `cd`s to ranger's pwd on close."
      set tempfile '/tmp/chosendir'
      env EDITOR=nvr command ranger --choosedir=$tempfile (pwd)

      if test -f $tempfile
          if [ (cat $tempfile) != (pwd) ]
            cd (cat $tempfile)
          end
      end

      rm -f $tempfile
    end

    # aws completion
    complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

    if type -q direnv
        direnv hook fish | source
    end

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

    set -x PAGER less
    set -x EDITOR nvim
    set -x VISUAL nvim
end
