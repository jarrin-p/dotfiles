let
  pinned_pkg_commit = "4ecab3273592f27479a583fb6d975d4aba3486fe";
  pkgs = import (fetchTarball ("http://github.com/NixOS/nixpkgs/archive/" + pinned_pkg_commit + ".tar.gz")) {};
in
  with pkgs; buildEnv {
    name = "mainEnv";
    paths = [
        (gradle_7.override{ java = jdk11; })
        (import ./packages/python.nix { pkgs = pkgs; })
        (import ./packages/fennel.nix { pkgs = pkgs; })
        (import ./jdtls/default.nix { pkgs = pkgs; })
        (import ./packages/nvim.nix { pkgs = pkgs; })
        # (import ./groovyls/default.nix { pkgs = pkgs; })

        # this specifies its own version of nixpkgs to get a specific version of terraform.
        (import ./packages/terraform.nix {})
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
        fish
        fnlfmt
        fzf
        gh
        git
        google-java-format
        jdk11
        jq
        luaformatter
        moar
        neovim-remote
        nil # nix language server.
        nodejs_20
        nodePackages_latest.dockerfile-language-server-nodejs
        nodePackages_latest.typescript
        nodePackages_latest.typescript-language-server
        nodePackages_latest.pyright
        nodePackages_latest.vscode-css-languageserver-bin
        nodePackages_latest.vscode-json-languageserver
        nodePackages_latest.vscode-html-languageserver-bin
        pylint
        ranger
        readline
        redis
        rename
        ripgrep
        rustc
        rust-analyzer
        sbt
        stow
        sumneko-lua-language-server
        terraform-ls
        tree
        tmux
        visidata
        wget
        yq
        ];
}
# broken packages.
# pkcs11helper
# rtorrent
