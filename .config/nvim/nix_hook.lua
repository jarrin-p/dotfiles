--- using `setup.lua` instead of `init.lua` because init is on the lua search path already,
--- however it is desired for this to be called before nvim calls anything else.
require "os"

local home_dir = os.getenv("HOME")
os.execute("cd " .. home_dir .. "/.config && make build")

require "utils"
require "plugins"
