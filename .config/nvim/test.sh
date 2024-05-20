#!/usr/bin/env sh

utils() {
    nvim --headless +"lua require 'tests.utils_test'" +q
}

hex_tool() {
    rm hex-tool.lua 2>/dev/null # want to import .fnl directly for testing convenience.
    fennel tests/test-hex-tool.fnl
}

all() {
    utils
    hex_tool
}

while ! test -z "$1"
do
    $1
    shift
done
