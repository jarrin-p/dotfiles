-- Setup folder checking.
require 'os'
local rc_path, suffix = os.getenv('MYVIMRC'), ''
if rc_path:match('.lua') then suffix = '.lua' else suffix = '.vim' end

-- helper function
local exec = function (str) vim.api.nvim_exec(str, false) end

-- add path so require function will find additional folders
package.path = string.gsub(rc_path, 'init' .. suffix, '') .. 'requires/?.lua;' .. package.path

-- Bring in all the settings
require 'Plugins'
require 'Surround'
require 'Commands'
require 'AutoCmd'
require 'ColorScheme'
require 'Settings'
require 'Remaps'

require 'nvim-treesitter.configs'.setup {
	-- One of "all", "maintained" (parsers with maintainers), or a list of languages
	ensure_installed = "all",

	-- Install languages synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- List of parsers to ignore installing
	-- ignore_install = { "javascript" },

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- list of language that will be disabled
		--disable = { "c", "rust" },

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}
