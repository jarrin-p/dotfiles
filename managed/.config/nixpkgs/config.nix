{
  packageOverrides = pkgs: with pkgs; {
    # don't need this on every computer.
    transmission = pkgs.buildEnv {
      name = "transmission";
      paths = [
        transmission
      ];
    };

    luaEnv = lua5_3.withPackages (ps: with ps; [ luacheck ]);

    py38 = pkgs.python38.withPackages (ps: with ps; [
      boto3
      pandas
      psycopg2
      pytest
      requests
      virtualenv
    ]);

    mainEnv = pkgs.buildEnv {
      name = "mainEnv";
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
