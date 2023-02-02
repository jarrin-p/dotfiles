let
  pkgs = import <nixpkgs> {};
  ppython39 = (pkgs.python39.withPackages (ps: with ps; [
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
            sqlparse
            urllib3
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
                lsp_signature-nvim
                luasnip
                minimap-vim
                neoscroll-nvim
                nord-vim
                nvim-cmp
                nvim-jdtls
                nvim-lspconfig
                plenary-nvim
                rust-tools-nvim
                vim-fugitive
                vim-surround
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
        jdk17
        jdt-language-server
        jq
        luaformatter
        neovim
        neovim-remote
        nil # nix language server.
        nodejs-slim-14_x
        nodePackages.npm
        nodePackages.typescript
        nodePackages.typescript-language-server
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
