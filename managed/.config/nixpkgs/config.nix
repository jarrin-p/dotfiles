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
        (lua5_3.withPackages (ps: with ps; [ luacheck ]))
        (python39.withPackages (ps: with ps; [ boto3 pandas psycopg2 pytest requests virtualenv XlsxWriter ]))
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
        jdk17
        jq
        luaformatter
        neovim
        nmap
        pkcs11helper
        ranger
        rename
        ripgrep
        rtorrent
        stow
        terraform
        wget
        youtube-dl
        zsh-vi-mode
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
