{
    packageOverrides = pkgs: with pkgs; {
        luaEnv = lua5_3.withPackages (ps: with ps; [ luacheck ]);

        py38 = pkgs.python38.withPackages (ps: with ps; [
                pandas
                requests
                psycopg2
                boto3
                virtualenv
        ]);

        myPackages = pkgs.buildEnv {
            name = "my-packages";
            paths = [
                bear
                    black
                    cargo
                    cmake
                    curl
                    ffmpeg
                    fzf
                    gh
                    git
                    gradle
                    jq
                    rename
                    pkcs11helper
                    rtorrent
                    ranger
                    ripgrep
                    stow
                    terraform
                    youtube-dl
                    zsh-vi-mode
                    zsh-z
                    ];
            pathsToLink = [ "/share" "/share/man" "/share/doc" "/bin" ];
            extraOutputsToInstall = [ "man" "doc" ];
        };
    };
}
