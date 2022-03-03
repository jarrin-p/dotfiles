require "os"
require "io"

local ext_list = 'coc-ext-list.txt'
local script_path = 'coc-ext-install.lua'
local file = io.open(ext_list, 'r')
local beginning = 'nvim --headless -c "CocInstall -sync '
local ending = '" -c "qa"'
local command = 'nvim --headless -c "5sleep" -c "qa!" -- ' .. script_path
os.execute(command)

for line in file:lines() do
	command = beginning .. line .. ending
	print(command)
	os.execute(command)
end

-- Attempting to get the lua lsp installed through shell, but
-- theycommands are async I can't define clear start/stops for the
-- install, and also it doesn't seem to want to install without
-- nvim being open. Whatever, it's a quick install.
--command = 'timeout 30s nvim -c "CocCommand sumneko-lua.install"'
--command = 'nvim -c "5sleep" -c "CocCommand sumneko-lua.install" -c "20sleep" -c "qa!" -- ' .. script_path
--print(command)
--os.execute(command)
