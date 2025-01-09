# was really hoping to be able to use something like `x@{fnargs...}` here
# in order to pass it to `buildEnv`, but I think that this running via `callPackage`
# is adding some fields that aren't being filtered out in a way I understand.
# ie, `s@{<args>}, (filter (arg not derivation) s)` still has functions in it.
{
  # the remaining are attributes of the nixpkgs set and will be
  # provided by `callPackage` if not given.

  # nixpkgs methods.
  buildEnv,
  callPackage,

  # unmodified pkgs.
  ansifilter,
  bash-language-server,
  black,
  code-minimap,
  coursier,
  curl,
  elan,
  fennel,
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
  haskellPackages,
  jq,
  luaformatter,
  metals,
  moar,
  pandoc,
  # python311Packages.sqlparse,
  poppler_utils,
  readline,
  redis,
  rename,
  ripgrep,
  sshfs,
  unzip,
  visidata,
  wget,
  yq,
  zip,

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
          # version of rtorrent that isn't broken.
      ++ [
          als
          ansifilter
          bat-overlay
          bash-language-server
          black
          code-minimap
          coreutils-full
          coursier
          curl
          direnv
          dots-script
          elan
          fennel
          ffmpeg
          fd
          fish-overlay
          fnlfmt
          fzf
          gettext
          gh
          (haskellPackages.ghcWithPackages (hpkgs: [hpkgs.shake]))
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
          metals
          moar
          nvim
          nvim-debug
          readline
          pandoc
          poppler_utils
          redis
          rename
          ripgrep
          sd
          sshfs
          tmux
          tree
          unzip
          visidata
          wget
          yq
          zip
        ];
}
# broken packages.
# pkcs11helper
# luaformatter
# nvimpager
