# description
an ongoing, unstable home for many of my dotfiles. neovim config receives the most updates.

readme is very wip.

`nix` is used to manage dependencies for all applications as part of the development environment, but dotfiles are managed through `stow` for symlinking, in order to attempt to keep runtime config separate from setup config.

## notes
- `stow` is used for creating dotfile symlinks into the home directory. please read about `stow` if you are not familiar.
- current setup only supports bringing in everything, so the overall size of packages could be large since I use a few different versions of the jdk.

## getting started
### requirements
- gnu stow [(link)](https://www.gnu.org/software/stow/)
- nix [(link)](https://nixos.org)

### setup
- `nix-env -iA nixpkgs.mainEnv` to install the setup.
