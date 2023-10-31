# `find` needs the trailing slash to indicate it's a directory.
config := $(HOME)/.config/nvim/

fennel_files = $(shell find -E $(config) \
        -not -type d \
        -and -name '*.fnl')

lua_files = $(fennel_files:.fnl=.lua)

%.lua: %.fnl
	@fennel --compile $< > $@

.PHONY: build
build: $(lua_files)
