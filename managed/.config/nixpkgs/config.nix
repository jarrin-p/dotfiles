{
  packageOverrides = pkgs: {

    gradleJdk11 = with pkgs; pkgs.buildEnv {
        name = "gradleJdk11";
        paths = [
            (gradle_7.override{ java = jdk11; })
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
                  local config_path = os.getenv("HOME") .. "/.config/nvim/"
                  package.path = config_path .. "?.lua;" .. package.path

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
                (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
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
    };
  };
}
