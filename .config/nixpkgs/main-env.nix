let
  pkgs = import (builtins.fetchGit {
    name = "nixpkgs-23-11";
    url = "https://github.com/nixos/nixpkgs/";
    ref = "refs/tags/23.11";
  }) {};
in
  with pkgs; buildEnv {
    name = "mainEnv";
    paths = [
        (gradle_7.override{ java = jdk11; })
        (import ./packages/fennel.nix { pkgs = pkgs; })
        (import ./jdtls/default.nix { pkgs = pkgs; })
        (import ./packages/nvim.nix { pkgs = pkgs; })
        (import ./packages/rtorrent.nix {})
        # (import ./packages/python.nix { pkgs = pkgs; })
        # (import ./groovyls/default.nix { pkgs = pkgs; })

        # this specifies its own version of nixpkgs to get a specific version of terraform.
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
        google-java-format
        gnumake
        jdk11
        jq
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
        python310
        ranger
        readline
        redis
        rename
        ripgrep
        rustc
        rust-analyzer
        # scala-cli
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
# luaformatter
