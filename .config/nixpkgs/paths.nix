{
  overrides ? {}
}:
{
    # want the helper tool to notice updates. if this were a path,
    # it would be stored in the nix-store, and thus would never look like
    # it changes.
    this = toString ./main-env.nix;

    colors = ../../base16.theme.json;
    fish = ../fish/config.fish;
    fishhook = ./packages/fish;
    lf_config_home = builtins.path { name = "lf_config_home"; path = ../../.config; };
    nixconf = ../nix/nix.conf;
    root = ../../.;
    tmux = builtins.path { name = "tmux_config"; path = ../tmux/.tmux.conf; };
}
