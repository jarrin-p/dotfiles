{
  packageOverrides = pkgs: {
    # don't need this on every computer.
    transmission = with pkgs; pkgs.buildEnv {
      name = "transmission";
      paths = [
        transmission
      ];
    };

    luaEnv = with pkgs; lua5_3.withPackages (ps: with ps; [ luacheck ]);

    py39 = with pkgs; python39.withPackages (ps: with ps; [
      boto3
      pandas
      psycopg2
      pytest
      requests
      virtualenv
    ]);

    j11 = with pkgs; pkgs.buildEnv {
        name = "j11";
        paths = [
            (gradle_7.override{ java = jdk11; })
        ];
    };

    j17 = with pkgs; pkgs.buildEnv {
        name = "j17";
        paths = [
            (gradle_7.override{ java = jdk17; })
        ];
    };

    mainEnv = with pkgs; pkgs.buildEnv {
      name = "mainEnv";
      paths = [
        bear
        black
        cargo
        cmake
        coreutils-full
        coursier
        curl
        ffmpeg
        fzf
        gh
        git
        jq
        neovim
        nmap
        pkcs11helper
        rename
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
