-- Setup folder checking.
require 'os'
local rc_path, suffix = os.getenv('MYVIMRC'), ''
if rc_path:match('.lua') then suffix = '.lua' else suffix = '.vim' end

-- add path so require function will find additional files in `requires` subfolder
package.path = string.gsub(rc_path, 'init' .. suffix, '') .. 'requires/?.lua;' .. package.path

-- general settings
require 'Util'
require 'Plugins'
require 'Commands'
require 'AutoCmd'
require 'Settings'
require 'Remaps'
require 'ColorScheme'
require 'Snippets'
require 'Menus'

-- specific files
require 'Statusline'
require 'LessChords'
