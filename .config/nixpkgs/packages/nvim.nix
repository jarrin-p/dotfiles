{ neovim, vimPlugins, runCommand, fd, coreutils-full, findutils}:
let
  config = ../../nvim;
  vimpaths = runCommand "built-nvim-plugins" {} ''
    export PATH=$PATH:${fd}/bin:${coreutils-full}/bin:${findutils}/bin
    mkdir -p $out/share
    cd $out/share
    files=$(fd '.fnl' ${config} --type f)
    echo "starting loop over fennel files."
    for f in $files
    do
      echo "f: '$f'"
      mkdir -p $(dirname $f)
      fennel --compile $f > $out/share/$f
    done

    luafiles=$(fd '.lua' ${config} --type f)
    echo "starting loop over lua files."
    for f in $luafiles
    do
      mkdir -p $(dirname $f)
      cp $f $out/share/$f
    done
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
