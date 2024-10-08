# original functions generated by `direnv hook fish`.
# $NIX_DIRENV_LOCATION acts as a temporary location for direnv hook
# to allow direnv to stay isolated.

function __direnv_export_eval --on-event fish_prompt;
    set -l temp_xdg $XDG_CONFIG_HOME
    set -x XDG_CONFIG_HOME $NIX_DIRENV_LOCATION
    "$DIRENV_BIN" export fish | source;

    if test "$direnv_fish_mode" != "disable_arrow";
        function __direnv_cd_hook --on-variable PWD;
            if test "$direnv_fish_mode" = "eval_after_arrow";
                set -g __direnv_export_again 0;
            else;
                "$DIRENV_BIN" export fish | source;
            end;
        end;
    end;
    set -x XDG_CONFIG_HOME $temp_xdg
end;

function __direnv_export_eval_2 --on-event fish_preexec;
    set -l temp_xdg $XDG_CONFIG_HOME
    set -x XDG_CONFIG_HOME $NIX_DIRENV_LOCATION
    if set -q __direnv_export_again;
        set -e __direnv_export_again;
        "$DIRENV_BIN" export fish | source;
        echo;
    end;

    functions --erase __direnv_cd_hook;
    set -x XDG_CONFIG_HOME $temp_xdg
end;
