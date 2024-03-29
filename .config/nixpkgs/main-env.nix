let
  pkgs = import (builtins.fetchTarball { url = "https://api.github.com/repos/nixos/nixpkgs/tarball/23.11"; }) {};
in
  with pkgs; buildEnv {
    name = "mainEnv";
    paths =
      (import ./packages/lsp.nix { pkgs = pkgs; }) ++
        [
          (gradle_7.override{ java = jdk11; })
          (import ./packages/fennel.nix { pkgs = pkgs; })
          (import ./packages/nvim.nix { pkgs = pkgs; })

          # version of rtorrent that doesn't break.
          (import ./packages/rtorrent.nix {})

          # version 1.15 of terraform.
          (import ./packages/terraform.nix {})

          ansifilter # an actual savior.
          bat
          bitwarden-cli
          black
          cargo
          code-minimap
          coreutils-full
          coursier
          curl
          direnv
          ffmpeg
          fd
          fish
          fnlfmt
          fzf
          gh
          git
          glab
          google-java-format
          gnumake
          gum
          jdk11
          jq
          lf
          moar
          neovim-remote
          nodejs_20
          nodePackages_latest.typescript
          nodePackages_latest.pyright
          pylint
          python311Packages.sqlparse
          python310
          readline
          redis
          rename
          ripgrep
          rustc
          rust-analyzer
          stow
          tree
          tmux
          visidata
          wget
          yq
        ];
}
# broken packages.
# pkcs11helper
# luaformatter
