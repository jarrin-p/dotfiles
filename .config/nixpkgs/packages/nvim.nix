{ neovim, vimPlugins }:
(neovim.override {
            configure = {
              # a hack that allows nvim config to exist without nix.
              customRC = ''
                lua << EOF
                  require "os"
                  package.path = package.path .. ";" .. os.getenv("DOTX_CONFIG_LOCATION") .. "/.config/nvim/?.lua"
                  require "nix-hook"
                EOF
              '';

              packages.myPlugins = with vimPlugins; {
                start = [
                  base16-vim
                  cmp-nvim-lsp
                  cmp-nvim-lsp-signature-help
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
                  symbols-outline-nvim
                  vim-closetag
                  vim-fish
                  vim-fugitive
                  vim-nickel
                  vim-nix
                  vim-surround
                  vim-terraform
                  vim-terraform-completion

                  # occasionally may need to remove, collect-garbage, re-install due to how tree-sitter updates.
                  nvim-treesitter.withAllGrammars
                ];
                opt = [];
            };
          };
        })
