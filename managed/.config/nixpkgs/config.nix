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

    py39 = pkgs.python39.withPackages (ps: with ps; [
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
