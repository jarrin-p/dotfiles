set @edit:before-readline = $@edit:before-readline {
    try {
        var m = [("/Users/js/.nix-profile/bin/direnv" export elvish | from-json)]
        if (> (count $m) 0) {
            set m = (all $m)
            keys $m | each { |k|
                if $m[$k] { set-env $k $m[$k] } else { unset-env $k }
            }
        }
    } catch e { echo $e }
}

set @edit:before-readline = $@edit:before-readline {
    tmux rename-window (pwd | str:split)
}

fn lf { cd (command lf) }
fn vsp { tmux split-window -h -c $E:PWD }
fn sp { tmux split-window -c $E:PWD }

eval (starship init elvish)
