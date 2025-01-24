{
  fd,
  fennel,
  metals,
  neovim,
  runCommand,
  sd,
  vimPlugins
}:
let
  config = ../../nvim;
  vimpaths = runCommand "vimpaths" {} ''
    export PATH=$PATH:${fd}/bin:${fennel}/bin:${sd}/bin
    cd ${config}
    fd --type directory | xargs -I% mkdir -p $out/share/%

    # aot compile fennel.
    for f in $(fd --type file ".fnl")
    do
      outpath="$out/share/$(sd --fixed-strings .fnl .lua <<< $f)"

      echo "compiling fennel to lua from '$f' to '$outpath'."
      fennel --compile $f > $outpath &
    done

    for f in $(fd --type file ".lua")
    do
      echo "copying lua from '$f' to '$out/share/$f'."
      cp $f $out/share/$f &
    done

    # obviously, wait until everything is finished.
    wait
  '';
in
neovim.override {
            configure = {
              customRC = ''
                lua << EOF
                  package.path = package.path .. ";" .. "${vimpaths}/share/?.lua;${fennel}/share/lua/5.2/?.lua"
                  vim.o.runtimepath = vim.o.runtimepath .. ",${vimpaths}/share,${vimpaths}/share/after"
                  vim.o.packpath = vim.o.packpath .. ",${vimpaths}/share,${vimpaths}/share/after"
                  vim.g.METALS_PATH = "${metals}/bin/metals"
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
                  nvim-notify
                  nvim-tree-lua
                  plenary-nvim
                  symbols-outline-nvim
                  vim-caddyfile
                  vim-closetag
                  vim-fish
                  vim-fugitive
                  vim-nickel
                  vim-nix
                  vim-surround
                  vim-table-mode
                  vim-terraform
                  vim-terraform-completion

                  # occasionally may need to remove, collect-garbage, re-install due to how tree-sitter updates.
                  nvim-treesitter.withAllGrammars
                ];
                opt = [];
            };
          };
        }
