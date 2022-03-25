require 'AutoloadClasses'

local exec = function (str) vim.api.nvim_exec(str, false) end

-- Open NERDTree as soon as Vim opens
AutoCmd:new{ event = 'VimEnter', nested = false, cmd = 'NERDTreeToggleVCS' }:add()

-- Ensure relative number is on. It makes navigating the tree even easier
AutoCmd:new{ event = 'VimEnter', nested = false, cmd = 'set relativenumber' }:add()

exec [[
augroup SHADA
    autocmd!
    autocmd CursorHold,TextYankPost,FocusGained,FocusLost *
        \ if exists(':rshada') | rshada | wshada | endif
augroup END
]]

