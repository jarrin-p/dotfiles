if status is-interactive

    # make fish more vi like.
    fish_vi_key_bindings

    # disable greeting.
    set fish_greeting ""

    set __fish_git_prompt_show_informative_status 1
    function fish_prompt
        set -l disp (string join / (string split -- / $PWD)[-2..-1])
        set_color blue
        # printf $PWD
        printf (fish_git_prompt)
        printf "\n"
        set_color white
        printf $USER
        set_color green
        printf " $disp > "
    end

    export PAGER=moar

    # fix wrongly ordered variables.
    fish_add_path $HOME/.nix-profile/bin
    fish_add_path /nix/var/nix/profiles/default/bin

    # load private files.
    if test -f $HOME/.fish.private; source $HOME/.fish.private; end

    function ls; command ls --group-directories-first --color $argv; end
    function gt; pushd $(git rev-parse --show-toplevel); end
    function GT; pushd $(git rev-parse --show-toplevel); end
    function g --description "Directly opens `Fugitive` in `nvim`."; nvim -c "Git" -c "only"; end
    function mainEnv --description "Updates current working environment."; nix-env -iA nixpkgs.mainEnv; end

    function tree; command tree --dirsfirst -AC --prune $argv; end

    # update ranger function to cd into the directory it currently landed on.
    function ranger --description "Opens `ranger` and `cd`s to ranger's pwd on close."
      set tempfile '/tmp/chosendir'
      command ranger --choosedir=$tempfile (pwd)

      if test -f $tempfile
          if [ (cat $tempfile) != (pwd) ]
            cd (cat $tempfile)
          end
      end

      rm -f $tempfile
    end


    # aws completion
    complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

end
