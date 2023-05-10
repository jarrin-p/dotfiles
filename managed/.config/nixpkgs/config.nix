let
  # pkgs = import <nixpkgs> {};
  ok = "cc45a3f8c98e1c33ca996e3504adefbf660a72d1";
  pkgs = import (fetchTarball ("http://github.com/NixOS/nixpkgs/archive/" + ok + ".tar.gz")) {};
  
  # pkgs = import (builtins.fetchGit {
  #   # Descriptive name to make the store path easier to identify
  #   name = "22.11";
  #   url = "https://github.com/nixos/nixpkgs";
  #   ref = "refs/tags/22.11";
  #   }) {};
  rust_analyzer_fix_commit = "a47f5d61ce06a433998fb5711f723773e3156f46";

  pinned_pkg_commit = "cc45a3f8c98e1c33ca996e3504adefbf660a72d1";
  pkgs = import (fetchTarball ("http://github.com/NixOS/nixpkgs/archive/" + pinned_pkg_commit + ".tar.gz")) {};
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
                nvim-tree-lua
                plenary-nvim
                (rust-tools-nvim.overrideAttrs (old: {
                  src = pkgs.fetchFromGitHub {
                    owner = "simrat39";
                    repo = "rust-tools.nvim";
                    rev = rust_analyzer_fix_commit;
                    hash = "sha256-82QOD4o6po9PHbYUdSEnJpf5yR9lru3GTLNvfRNFydg=";
                  };
                }))
                symbols-outline-nvim
                vim-fish
                vim-fugitive
                vim-nix
                vim-surround
                vim-terraform
                vim-terraform-completion
                vimwiki
                (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
                # (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
                #                     .overrideAttrs (old: { 
                #                         version = "2022-08-31";
                #                         src = pkgs.fetchFromGitHub { 
                #                             owner = "nvim-treesitter";
                #                             repo = "nvim-treesitter";
                #                             rev = "501db1459a7a46cb0766b3c56e9a6904bbcbcc97";
                #                             sha256 = "sha256-MGtvAtZ4VgZczalMlbftdTtPr6Ofxdkudpo6PmaVhtQ=";
                #                         };
                #                     })
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
        bat
        bear
        black
        cargo
        cmake
        code-minimap
        coreutils-full
        coursier
        curl
        direnv
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
        moar
        neovim
        neovim-remote
        nil # nix language server.
        nodejs-slim-14_x
        nodePackages.npm
        nodePackages.typescript
        nodePackages.typescript-language-server
        nodePackages.pyright
        nodePackages.cdktf-cli
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
