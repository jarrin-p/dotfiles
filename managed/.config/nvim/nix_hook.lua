--- using `setup.lua` instead of `init.lua` because init is on the lua search path already,
--- however it is desired for this to be called before nvim calls anything else.
require "os"

--- compile all fennel into lua first using fennel application (should be installed via nixpkgs).
--- this saves overhead of having to load fennel compiler into neovim each startup.
local aot_compile_filename = "fennel_aot_compile.fnl"
local command = "PACKAGE_PATH='" .. package.path .. "' fennel " .. os.getenv("HOME") .. "/.config/nvim/" .. aot_compile_filename
os.execute(command)
require "util"
require "plugins"
