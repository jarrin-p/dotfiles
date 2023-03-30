if status is-interactive
    # Commands to run in interactive sessions can go here
    # function ranger --description "cds to the directory on `Q`.";
    #     set -l tempfile
    # end
    fish_vi_key_bindings
    set fish_greeting ""
    set -g ranger_bin "$HOME/.nix-profile/bin/ranger"
    function ranger --description "a thing";
        set -l tempfile (mktemp tmp.XXXXXX)
        set -l ranger_cmd (command ranger --cmd="map Q chain shell echo %d > $tempfile; quitall")
    end
end
