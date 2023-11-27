# description
an ongoing, unstable home for many of my dotfiles. neovim config receives the most updates.

readme is very wip.

`nix` is used to manage dependencies for all applications as part of the development environment, but dotfiles are managed through `stow` for symlinking, in order to attempt to keep runtime config separate from setup config.

## notes
- current setup brings in all packages, including a few versions of jdk, so the overall size may be large.
- `stow` is used for creating dotfile symlinks into the home directory. please read about `stow` if you are not familiar.

## getting started
### minimum requirements
- nix [(link)](https://nixos.org)

### setup
to install all dependencies for the dotfiles, run from the root of the repository:
```sh
nix-env -if ./config/main-env.nix
```

then, you can use the helper script which will use `stow` (installed by nix) to symlink the dotfiles into the home directory. it will automatically get the relative path to your home directory.
```sh
./restow.sh
```

### uninstall
uninstall the nix derivation (its name is `mainEnv`, which can be seen in the file.)
```sh
nix-env --uninstall mainEnv
```

and if you symlinked everything, you can undo them with the `unstow.sh` helper.
```sh
./unstow.sh
```
