--- @author jarrin-p
--- @file `init.lua`
-- add folders to be required.
require 'os'
local rc_path, suffix = os.getenv('MYVIMRC'), ''
if rc_path ~= nil and rc_path:match('.lua') then
    suffix = '.lua'
else
    suffix = '.vim'
end

-- add path so require function will find additional files in `requires` subfolder
package.path = string.gsub(rc_path, 'init' .. suffix, '') .. '?.lua;' .. package.path

require 'util'
require 'plugins'
