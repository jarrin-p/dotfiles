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
        (neovim.override {
            configure = {
              customRC = ''
                lua << EOF
                  require "os"
                  local rc_path, suffix = os.getenv("MYVIMRC"), ""
                  if rc_path ~= nil and rc_path:match(".lua") then
                      suffix = ".lua"
                  else
                      suffix = ".vim"
                  end

                  -- add path so require function will find additional files in `current` dir.
                  package.path = string.gsub(rc_path, "init" .. suffix, "") .. "?.lua;" .. package.path

                  require "util"
                  require "plugins"
                EOF
              '';

              packages.myPlugins = with pkgs.vimPlugins; {
              start = [
                fzf-vim
                luasnip
                cmp-nvim-lsp
                nvim-cmp
                nvim-lspconfig
                plenary-nvim
                cmp_luasnip
                vim-fugitive
                vim-surround
                minimap-vim
                rust-tools-nvim
                nord-vim
              ];
              opt = [];
            };
          };
        })
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
        rust-analyzer
        sbt
        stow
        terraform
        tree
        tmux
        visidata
        wget
        youtube-dl
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
