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
- clone the repo **into one subdirectory**, such that `$HOME/some_dir/dotfiles` is the result. todo: make dynamic.
- note about this step: this will create symlinks in your home directory to match the file structure inside this repo, but stow should not overwrite files by default. if existing configurations exist, it may cause the stow option to fail.
    - quote from stow man page: "Stow will never delete anything that it doesn't own."
    - (the actual step) run `sh restow.sh`
- `nix-env -iA nixpkgs.mainEnv` to install the setup.

### uninstall
needs to be tested, but the general idea would be something like.
```
nix-env --uninstall mainEnv
cd .. && stow -D dotfiles -t ../
```

basically just standard `nix` uninstall and delete option with `stow`.
