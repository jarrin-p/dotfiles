let
  # easily find nixpkgs containing the version of software you need.

  pinned_pkg_commit = "4ecab3273592f27479a583fb6d975d4aba3486fe";
  pkgs = import (fetchTarball ("http://github.com/NixOS/nixpkgs/archive/" + pinned_pkg_commit + ".tar.gz")) {};

  fennelRepl = (pkgs.luajit.withPackages (ps: with ps; [
            fennel
            readline
            luacheck
            lyaml
        ]));

  # ppython39 = (pkgs.python310Full.withPackages (ps: with ps; [
  #           sqlparse
  #           pip
  #           virtualenv
  #       ]));
in
{
  allowUnfree = true;
  packageOverrides = pkgs: {

    # mostly keeping for reference to gradle/java version setting,
    gradleJdk11 = with pkgs; pkgs.buildEnv {
        name = "gradleJdk11";
        paths = [
            (gradle_7.override{ java = jdk11; })
        ];
    };

    mainEnv = with pkgs; pkgs.buildEnv {
      name = "mainEnv";
      paths = [
        (gradle_7.override{ java = jdk11; })
        bat
        bitwarden-cli
        black
        cargo
        code-minimap
        coreutils-full
        coursier
        curl
        direnv
        fennelRepl
        ffmpeg
        fish
        fnlfmt
        fzf
        gh
        git
        google-java-format
        (import ./groovyls/default.nix)
        jdk11
        (import ./jdtls/default.nix)
        jq
        luaformatter
        moar
        (import ./nvim/default.nix { pkgs = pkgs; })
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
        (import ./packages/terraform.nix {})
        terraform-ls
        tree
        tmux
        visidata
        wget
        yq
        ];
      pathsToLink = [ "/share" "/share/man" "/share/doc" "/bin" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
  };
}
# broken packages.
# pkcs11helper
# rtorrent
