# description
an ongoing, unstable home for many of my dotfiles. neovim config receives the most updates.

# as a heads up
the environment is a little bulky in size right now, since it comes with several language servers and a jdk. eventually this will be made more modular, but until then, that's the warning.

# setup
all you should need to get running is [nix](https://nixos.org). once you have that, you can just use the main environment `main-env.nix` file however you want, i.e. install it into your env, use it in a `shell.nix`, etc.

if you install, i.e. with the following,
```sh
nix-env -if ./.config/nixpkgs/main-env.nix
```

there are some helper commands that become available through an exectuable script `dots`. the contents are in `dots.nix`, but it basically just makes it easier to refresh the configuration or uninstall it if you want.

# uninstall
uninstall it like any other `nix` package. `nix-env --uninstall mainEnv` should do the trick.
