{ pkgs }:
let
  rust_analyzer_fix_commit = "a47f5d61ce06a433998fb5711f723773e3156f46";

  fennelRepl = (pkgs.luajit.withPackages (ps: with ps; [
            fennel
            readline
            luacheck
            lyaml
        ]));
in
(pkgs.neovim.override {
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
                nvim-metals
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
                vim-nickel
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
        })
