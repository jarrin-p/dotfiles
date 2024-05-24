# description
an ongoing, unstable home for many of my dotfiles. neovim config receives the most updates.

readme is very wip.

`nix` is used to manage dependencies for all applications as part of the development environment. cli applications use environment variables for pointing at configuration files. they are set automatically when sourcing a shell's rc file (currently on `fish` is up to date..).

## notes
- `stow` is used for creating dotfile symlinks into the home directory. please read about `stow` if you are not familiar. it shouldn't ovewrite existing files though.

## getting started
### minimum requirements
- [nix](https://nixos.org)

### setup
run this to install the packages from the nix file (just a wrapped `pkgs.buildEnv`).
```sh
./do refresh
```
(the `do` script doesn't actually do a whole lot, it's just a few preconfigured commands with a bit of feedback.)

after that, export the variable `DOTX_CONFIG_LOCATION` with a path to where this repository was cloned. you can then source the rc for your shell, and it'll set all the configuration environment variables for cli applications.

running
```sh
./do setup_shell
```
will automate that process for you and add it to startup rcs. only `fish` is configured for righ tnow.
