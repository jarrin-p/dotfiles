# description
an ongoing, unstable home for my development environment. it's basically my dotfiles wrapped in nix in a (probably awful) way allowing for a "nix 1-liner" to have my full development environment working.

generally, this is going to be pretty specific for how I like to develop, but you could always modify the `default.nix` for whatever changes you want.

# as a heads up
the might be a little bulky in size right now, since it comes with several language servers and a jdk. eventually this will be made more modular, but until then, that's the warning.

# setup
all you should need to get running is [nix](https://nixos.org). once you have that, you can just use the `default.nix` file however you want, as it returns a derivation of the environment. i.e, import and pass it to a shell, install it with `nix profile install --file default.nix` or `nix-env -if default.nix`, etc.

I tend to keep it as an install on my machine and then run the utility script `dots r` (for 'refresh') whenever I make an update, I guess kind of like a bootleg NixOS configuration. **note: `dots r` uses `nix profile` which will make your profile incompatible with `nix-env`.**

the `dots` utility that's added to `PATH` is basically a couple of aliases for shell commands.

# uninstall
uninstall it like any other `nix` package. `nix profile remove dotx-configuration` should do the trick.
