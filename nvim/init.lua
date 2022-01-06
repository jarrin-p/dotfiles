-- Setup folder checking.
require 'os'
local rc_path, suffix = os.getenv('MYVIMRC'), ''
if rc_path:match('.lua') then suffix = '.lua' else suffix = '.vim' end

-- add path so require function will find additional folders
package.path = string.gsub(rc_path, 'init' .. suffix, '') .. 'requires/?.lua;' .. package.path

-- Bring in all the settings
require 'Settings'
require 'Plugins'
require 'Surround'
require 'Remaps'
require 'AutoCmd'
require 'ColorScheme'
