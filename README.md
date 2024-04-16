# description
an ongoing, unstable home for many of my dotfiles. neovim config receives the most updates.

readme is very wip.

`nix` is used to manage dependencies for all applications as part of the development environment, but dotfiles are managed through `stow` for symlinking, in order to attempt to keep runtime config separate from setup config.

## notes
- `stow` is used for creating dotfile symlinks into the home directory. please read about `stow` if you are not familiar. it shouldn't ovewrite existing files though.

## getting started
### minimum requirements
- nix [(link)](https://nixos.org)

### setup
everything can be managed through a shell script. just run `./do` to see what's available.

to install all dependencies for the dotfiles, run from the root of the repository:
```sh
./do setup
```
