# `find` needs the trailing slash to indicate it's a directory.
config := $(HOME)/.config/nvim/

# all the fennel files that should be compiled.
fennel_files = $(shell find -E $(config) \
        -not -type d \
        -and -name '*.fnl')

# the expected lua files we should have generated.
lua_files = $(fennel_files:.fnl=.lua)

%.lua: %.fnl
	fennel --compile $< > $@

# build checks if all expected generated files are present.
# if they aren't, it runs the above rule.
.PHONY: build
build: $(lua_files)

.PHONY: clean_generated
clean_generated:
	echo $(lua_files) | xargs rm
