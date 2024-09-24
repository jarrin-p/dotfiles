# description
an ongoing, unstable home for my development environment. it's pretty much my attempt at a "portable" environment when using `nix` on multiple platforms (mac, wsl, ubuntu, etc).

generally, this is going to be pretty specific for how I like to develop, but you could always modify the `default.nix` for whatever changes you want.

# size warning.
the might be a little bulky in size right now, since it comes with several language servers and a jdk. eventually this will be made more modular, but until it's actively in my way, it's not a priority.

# setup
- have [nix](https://nixos.org) installed.
- run either:
    - `nix-env -if default.nix` (recommended)
    - `nix profile install --file default.nix` (this will cause your profile to become incompatible with `nix-env` in the future).

now you should have an `nvim` setup with several language servers, some useful cli tools with isolated configurations (`rg`, `fd`, `lf`, `direnv`, etc), and a `fish` shell with some variables automatically exported.

# tooling
to see a full list of tooling made available, check [.config/nixpkgs/main-env.nix](.config/nixpkgs/main-env.nix).

# uninstall
uninstall it like any other `nix` package. `nix-env --uninstall 'dotx-environment'` should do the trick.
