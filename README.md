# description
an ongoing, unstable home for many of my dotfiles. neovim config receives the most updates.

`nix` is used to manage dependencies for all applications as part of the development environment.

## getting started
### important notes
- current setup only supports bringing in everything, so the overall size of packages could be large since I use a few different versions of the jdk.
- `stow` is used for creating dotfile symlinks. please read about `stow` if you are not familiar.

### requirements
- gnu stow [(link)](https://www.gnu.org/software/stow/)
- nix [(link)](https://nixos.org)

### setup
- _WARNING:_ this will symlink files into your home directory. by default, `stow` will abort if a file exists with the name of a symlink it is trying to create. please read about `stow` to customize this command to your needs.  `stow -R managed -t ${HOME} && `
- `nix-env -iA nixpkgs.mainEnv` to install the setup.
