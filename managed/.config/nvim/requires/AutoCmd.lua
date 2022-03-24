require 'AutoloadClasses'

local exec = function (str) vim.api.nvim_exec(str, false) end

-- Open NERDTree as soon as Vim opens
AutoCmd:new{ event = 'VimEnter', nested = false, cmd = 'NERDTreeToggleVCS' }:add()

-- Then go to the next window
AutoCmd:new{ event = 'VimEnter', nested = false, cmd = 'wincmd l' }:add()

exec [[
augroup SHADA
    autocmd!
    autocmd CursorHold,TextYankPost,FocusGained,FocusLost *
        \ if exists(':rshada') | rshada | wshada | endif
augroup END
]]

