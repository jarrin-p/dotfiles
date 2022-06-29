{
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        bear
        cargo
        cmake
        curl
        ffmpeg
        fzf
        gh
        git
        gradle
        jq
        luarocks
        rename
        pkcs11helper
        rtorrent
        ranger
        ripgrep
        stow
        terraform
        youtube-dl
        zsh-vi-mode
        zsh-z
      ];
      pathsToLink = [ "/share" "/share/man" "/share/doc" "/bin" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
  };
}
