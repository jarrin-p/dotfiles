{ pkgs }: # whatever nixpkgs for these defaults.

# trying to avoid `with`.
builtins.attrValues {
  inherit (pkgs)
    ansifilter
    code-minimap
    coreutils-full
    coursier
    curl
    direnv
    elan
    ffmpeg
    fd
    fnlfmt
    fzf
    gettext
    gh
    git
    glow
    gnumake
    gnused
    gum
    jq
    luaformatter
    moar
    readline
    redis
    rename
    ripgrep
    sd
    visidata
    wget
    yq
  ;
}
