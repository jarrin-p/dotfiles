.PHONY: setup refresh

install:
	./restow.sh

refresh:
	nix-env -if .config/nixpkgs/main-env.nix
