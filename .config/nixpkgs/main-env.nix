{
  # the remaining are attributes of the nixpkgs set and will be
  # provided by `callPackage` if not given.

  # nixpkgs methods.
  buildEnv,
  callPackage,

  # unmodified pkgs.
  ansifilter,
  code-minimap,
  coursier,
  curl,
  elan,
  ffmpeg,
  fd,
  fnlfmt,
  fzf,
  gettext,
  gh,
  git,
  glow,
  gnumake,
  gnused,
  gum,
  jq,
  luaformatter,
  moar,
  # python311Packages.sqlparse,
  readline,
  redis,
  rename,
  ripgrep,
  visidata,
  wget,
  yq,

  # wrapped pkgs
  als,
  bat-overlay,
  bitwarden-cli,
  coreutils-full,
  direnv,
  dots-script,
  fish-overlay,
  git-root,
  git-ui,
  lf-overlay,
  nvim,
  nvim-debug,
  sd,
  tmux,
  tree,
}:
  buildEnv {
    name = "dotx-environment";
    paths =
         (if builtins.currentSystem == "aarch64-darwin" then [] else [bitwarden-cli])
      ++ (callPackage ./packages/lsp.nix {})
      ++ [
          # version of rtorrent that isn't broken.
          (import ./packages/rtorrent.nix {})

          als
          ansifilter
          bat-overlay
          code-minimap
          coreutils-full
          coursier
          curl
          direnv
          dots-script
          elan
          ffmpeg
          fd
          fish-overlay
          fnlfmt
          fzf
          gettext
          gh
          git
          git-ui
          git-root
          glow
          gnumake
          gnused
          gum
          jq
          lf-overlay
          luaformatter
          moar
          nvim
          nvim-debug
          readline
          redis
          rename
          ripgrep
          sd
          tmux
          tree
          visidata
          wget
          yq
        ];
}
# broken packages.
# pkcs11helper
# luaformatter
# nvimpager
