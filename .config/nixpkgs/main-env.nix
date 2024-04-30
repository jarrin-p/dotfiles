let
  pkgs = import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/23.11"; }) {};
  callPackage = pkgs.callPackage;
in
  pkgs.buildEnv {
    name = "mainEnv";
    paths =
      (import ./packages/lsp.nix { pkgs = pkgs; }) ++
        [
          (pkgs.gradle_7.override{ java = pkgs.jdk11; })

          (callPackage ./packages/fennel.nix {})
          (callPackage ./packages/nvim.nix {})

          # version of rtorrent that doesn't break.
          (import ./packages/rtorrent.nix {})

          # version 1.15 of terraform.
          (import ./packages/terraform.nix {})

          pkgs.ansifilter # an actual savior.
          pkgs.bat
          pkgs.bitwarden-cli
          pkgs.cargo
          pkgs.code-minimap
          pkgs.coreutils-full
          pkgs.coursier
          pkgs.curl
          pkgs.direnv
          pkgs.ffmpeg
          pkgs.fd
          pkgs.fish
          pkgs.fnlfmt
          pkgs.fzf
          pkgs.gettext
          pkgs.gh
          pkgs.git
          pkgs.glow
          pkgs.gnumake
          pkgs.gum
          pkgs.haskellPackages.hoogle
          pkgs.jq
          pkgs.lf
          pkgs.moar
          pkgs.neovim-remote
          pkgs.nodePackages_latest.pyright
          pkgs.nvimpager
          pkgs.pylint
          pkgs.python311Packages.sqlparse
          pkgs.python310
          pkgs.readline
          pkgs.redis
          pkgs.rename
          pkgs.ripgrep
          pkgs.stow
          pkgs.tree
          pkgs.tmux
          pkgs.universal-ctags
          pkgs.visidata
          pkgs.wget
          pkgs.yq
        ];
}
# broken packages.
# pkcs11helper
# luaformatter
