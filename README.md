# description
an ongoing, unstable home for my development environment. it's pretty much my attempt at a batteries included, portable, cli-driven environment when using `nix` on multiple platforms (mac, wsl, ubuntu, etc).

generally, this is going to be pretty specific for how I like to develop, but you could always modify the `default.nix` for whatever changes you want.

> !NOTE size disclaimer
> this might be a little bulky in size, since it comes with several language servers and a jdk. eventually this will be made more modular, but until it's actively in my way, it's not a priority.

# setup as standalone environment
- have [nix](https://nixos.org) installed.
- run either:
    - `nix-env -if default.nix` (recommended)
    - `nix profile install --file default.nix` (this will cause your profile to become incompatible with `nix-env` in the future).

now you should have an `nvim` setup with several language servers, some useful cli tools with isolated configurations (`fzf`, `rg`, `fd`, `lf`, `direnv`, etc), and a `fish` shell with some variables automatically exported.

you could theoretically use this in a `nix-shell` as well if the needs called for it, by importing the `default.nix` and adding the import to the paths listed in a `pkgs.mkShell` call.

# tooling
to see a full list of tooling made available, check [.config/nixpkgs/main-env.nix](.config/nixpkgs/main-env.nix).

# configured lsp's in `nvim`
there are several language servers that have been configured with this setup, and should work out of the box with the `nvim` that comes with this environment.

> [!NOTE]
> I've used all the servers here at least for a bit. the experience with some is a little rougher than others.

off the top of my head, here's a list of configured languages/servers that I have used. there are more, but they're probably not as tested.
- scala - `metals` (requires installed `jdk` > 17 I think, this will be fixed eventually). tested mostly with `sbt`. works with `scala-cli` scripts as well.
- java (with lombok annotation support) - `jdtls` through `nvim-jdtls` plugin.
- rust - `rust_analyzer`
- nix - `nil`
- fennel - `fennel_ls`
- lean - lean's builtin lsp + `lean-nvim`.
- lua - `lua_ls`, also sets the vimruntime as a global workspace.
- terraform - `terraformls` (rough) (can be slow and/or freeze sometimes.)
- json, yaml - `jsonls`, `yamlls` - should tell you when json or yaml are improperly formatted.
- javascript, typescript - `typescript-language-server`. (rough) (typescript occasionally needs restarting but js seems find.)
- latex - `texlab` - autocomplete doesn't help substantially with parameters, but it's pretty snappy overall.

## additional language configuration
the easiest way to check what additional features, snippets, etc, I may have added for a language would be to look at the filetype config located in [.config/nvim/ftplugin](.config/nvim/ftplugin).

for example, `tex` files add an autocommand to run `:make` on save if a makefile is present in the pwd. this works nicely when the pdf you're working on is loaded in a viewer and supports auto-reloading.

# some current works in progress and/or ideas.
- externalize the color scheme to a json file in order to unify app color schemes. the bulk of this is actually updating all the `nvim` highlight groups to retain good syntax highlighting.
- fix some of the lsp's.
- clean up the `nixpkgs` directory.
- add modularity / slim installs.
- add the ability to build the preconfigured environment into a standalone package (i.e, without nix, download release, add ./release/bin to path, full env is ready to go).

# uninstall
uninstall it like any other `nix` package. `nix-env --uninstall 'dotx-environment'` should do the trick.
