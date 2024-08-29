{ neovim, vimPlugins, runCommand, fd, fennel }:
let
  config = ../../nvim;
  vimpaths = runCommand "vimpaths" {} ''
    export PATH=$PATH:${fd}/bin:${fennel}/bin
    cd ${config}
    fd --type directory | xargs -I% mkdir -p $out/share/%

    # aot compile fennel.
    for f in $(fd --type file ".fnl")
    do
      echo "compiling fennel to lua from '$f' to '$out/share/$f.lua'."
      fennel --compile $f > $out/share/$f.lua &
    done

    for f in $(fd --type file ".lua")
    do
      echo "copying lua from '$f' to '$out/share/$f'."
      cp $f $out/share/$f &
    done
    wait
  '';
in
neovim.override {
            configure = {
              customRC = ''
                lua << EOF
                  package.path = package.path .. ";" .. "${vimpaths}/share/?.fnl.lua"
                  vim.o.runtimepath = vim.o.runtimepath .. ",${vimpaths}/share,${vimpaths}/share/after"
                  vim.o.packpath = vim.o.packpath .. ",${vimpaths}/share,${vimpaths}/share/after"

                  -- for some reason these need to be set before anything else.
                  vim.cmd('let g:gruvbox_material_enable_italic = 1')
                  vim.cmd('colorscheme gruvbox-material')
                  require "utils"
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
        }
