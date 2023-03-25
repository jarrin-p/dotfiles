--- @author jarrin-p
--- @file `commands.lua`
local util = require 'util'

-- changes current directory to the root of the git repository.
util.exec([[ command! GT execute 'lcd' fnameescape(FugitiveWorkTree())]], false)

-- loads the Sessiom.vim from the root of the git directory if in one.
vim.api.nvim_create_user_command('LG', util.load_session_from_git_root, {})

-- formats the file using formatprg while keeping the cursor position.
vim.api.nvim_create_user_command('FF', util.file_format, {})

local go = function()
    util.exec([[ silent !tmux split-window -h -c $(dirname %) ]])
end
vim.api.nvim_create_user_command('GO', go, {})

-- vim: fdm=marker foldlevel=0
