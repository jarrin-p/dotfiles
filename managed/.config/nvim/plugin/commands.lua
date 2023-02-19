--- @author jarrin-p
--- @file `commands.lua`
local util = require 'util'
-- changes current directory to the root of the git repository.
util.exec([[ command! GT execute 'cd' fnameescape(FugitiveWorkTree())]], false)

-- loads the Sessiom.vim from the root of the git directory if in one.
vim.api.nvim_create_user_command('LG', util.load_session_from_git_root, {})

-- alias for opening quickfix list to a new tab.
util.exec([[ command! CO tabnew | copen | only]], false)

-- creates a floating term that can quickly be destroyed.
util.exec([[ command! T lua FloatingTerm() ]], false)

-- vim: fdm=marker foldlevel=0
