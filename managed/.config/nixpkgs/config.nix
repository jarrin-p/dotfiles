let
  rust_analyzer_fix_commit = "a47f5d61ce06a433998fb5711f723773e3156f46";

  pinned_pkg_commit = "4ecab3273592f27479a583fb6d975d4aba3486fe";
  pkgs = import (fetchTarball ("http://github.com/NixOS/nixpkgs/archive/" + pinned_pkg_commit + ".tar.gz")) {};

  fennelRepl = (pkgs.luajit.withPackages (ps: with ps; [
            fennel
            readline
            luacheck
        ]));

  ppython39 = (pkgs.python310Full.withPackages (ps: with ps; [
            sqlparse
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
                  package.path = "${fennelRepl}/share/lua/5.1/" .. "?.lua;" .. package.path
                  require "nix_hook"
                EOF
              '';

              packages.myPlugins = with pkgs.vimPlugins; {
              start = [
                base16-vim
                conjure
                cmp-nvim-lsp
                cmp_luasnip
                fzf-vim
                gruvbox-material
                luasnip
                minimap-vim
                neoscroll-nvim
                null-ls-nvim
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
                vim-closetag
                vim-fish
                vim-fugitive
                vim-nix
                vim-surround
                vim-terraform
                vim-terraform-completion
                vimwiki

                # occasionally may need to remove, collect-garbage, re-install due to how tree-sitter updates.
                nvim-treesitter.withAllGrammars
              ];
              opt = [];
            };
          };
        });
in
{
  packageOverrides = pkgs: {

    # mostly keeping for reference to gradle/java version setting,
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
        fennelRepl
        ffmpeg
        fish
        fnlfmt
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
        # nodePackages_latest.cdktf-cli
        nodePackages_latest.dockerfile-language-server-nodejs
        nodePackages_latest.npm
        nodePackages_latest.typescript
        nodePackages_latest.typescript-language-server
        nodePackages_latest.pyright
        nodePackages_latest.vscode-css-languageserver-bin
        nodePackages_latest.vscode-json-languageserver
        nodePackages_latest.vscode-html-languageserver-bin
        nmap
        pkcs11helper
        pylint
        ranger
        readline
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
        tflint
        tflint-plugins.tflint-ruleset-aws
        tree
        tmux
        visidata
        wget
        yq
        zsh-z
        ];
      pathsToLink = [ "/share" "/share/man" "/share/doc" "/bin" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
  };
}
