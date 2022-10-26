{
  packageOverrides = pkgs: {

    # don't need this on every computer.
    transmission = with pkgs; pkgs.buildEnv {
      name = "transmission";
      paths = [
        transmission
      ];
    };

    gradleJdk11 = with pkgs; pkgs.buildEnv {
        name = "gradleJdk11";
        paths = [
            (gradle_7.override{ java = jdk11; })
        ];
    };

    gradleJdk17 = with pkgs; pkgs.buildEnv {
        name = "gradleJdk17";
        paths = [
            (gradle_7.override{ java = jdk17; })
        ];
    };

    mainEnv = with pkgs; pkgs.buildEnv {
      name = "mainEnv";
      paths = [
        (gradle_7.override{ java = jdk11; })
        (lua5_3.withPackages (ps: with ps; [
            luacheck
        ]))
        (python39.withPackages (ps: with ps; [
            XlsxWriter
            boto3
            certifi
            charset-normalizer
            idna
            openpyxl
            pandas
            psycopg2
            pytest
            requests
            urllib3
            virtualenv
        ]))
        alacritty
        bear
        black
        cargo
        cmake
        code-minimap
        coreutils-full
        coursier
        curl
        ffmpeg
        fzf
        gh
        git
        jdk17
        jq
        luaformatter
        neovim
        neovim-remote
        nodejs-slim-14_x
        nodePackages.npm
        nmap
        pkcs11helper
        ranger
        rename
        ripgrep
        rtorrent
        rustc
        sbt
        stow
        terraform
        tmux
        visidata
        wget
        youtube-dl
        # zsh-vi-mode
        zsh-z
      ];
      pathsToLink = [ "/share" "/share/man" "/share/doc" "/bin" ];
      extraOutputsToInstall = [ "man" "doc" ];
      # TODO get post build script working.
      # postBuild = ''
      #   CS_CACHE=$out/cs_cache
      #   echo $CS_CACHE
      #   mkdir $out/cs_cache
      #   $out/bin/cs setup --cache $CS_CACHE -y
      #   $out/bin/cs install scala
      # '';
    };
  };
}
