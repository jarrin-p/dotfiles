{ neovim, vimPlugins, runCommand, fd, coreutils-full, fennel }:
let
  config = ../../nvim;
  builder = import ../util/default.nix {};
  vimpaths = runCommand "vimpaths" {} ''
    export PATH=$PATH:${builder}/bin
    mkdir -p $out/share
    prepvim ${config} $out/share ${fd}/bin/fd ${fennel}/bin/fennel
  '';
in
(neovim.override {
            configure = {
              customRC = ''
                lua << EOF
                  require "os"
                  package.path = package.path .. ";" .. "${vimpaths}/share/?.lua"
                  vim.o.runtimepath = vim.o.runtimepath .. ",${vimpaths}/share,${vimpaths}/share/after"
                  vim.o.packpath = vim.o.packpath .. ",${vimpaths}/share,${vimpaths}/share/after"
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
                  lean-nvim
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
