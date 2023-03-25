let
  pkgs = import <nixpkgs> {};
  ppython39 = (pkgs.python310Full.withPackages (ps: with ps; [
            # XlsxWriter
            # boto3
            # certifi
            # charset-normalizer
            # idna
            # openpyxl
            # pandas
            # psycopg2
            # pytest
            # requests
            sqlparse
            # urllib3
            pip
            virtualenv
        ]));

  neovim = (pkgs.neovim.override {
            configure = {
              # a hack that allows nvim config to exist without nix.
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
                cmp-nvim-lsp
                cmp_luasnip
                fzf-vim
                gruvbox-material
                luasnip
                minimap-vim
                neoscroll-nvim
                nvim-cmp
                nvim-jdtls
                nvim-lspconfig
                plenary-nvim
                rust-tools-nvim
                symbols-outline-nvim
                vim-fugitive
                vim-nix
                vim-surround
                vim-terraform
                vimwiki
                (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
              ];
              opt = [];
            };
          };
        });
in
{
  packageOverrides = pkgs: {

    # mostly keeping for reference to gradle/java version setting,
    # since I feel likely to forget as a nix beginner.
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
        (lua5_3.withPackages (ps: [ ps.luacheck ]))
        ppython39
        bear
        black
        cargo
        cmake
        code-minimap
        coreutils-full
        coursier
        curl
        ffmpeg
        fish
        fzf
        gh
        git
        google-java-format
        jdk11
        (import ./jdtls/default.nix)
        jq
        luaformatter
        neovim
        neovim-remote
        nil # nix language server.
        nodejs-slim-14_x
        nodePackages.npm
        nodePackages.typescript
        nodePackages.typescript-language-server
        nodePackages.pyright
        nodePackages.vscode-json-languageserver
        nmap
        pkcs11helper
        pylint
        ranger
        redis
        rename
        ripgrep
        rtorrent
        rustc
        rust-analyzer
        sbt
        stow
        sumneko-lua-language-server
        terraform
        terraform-ls
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
