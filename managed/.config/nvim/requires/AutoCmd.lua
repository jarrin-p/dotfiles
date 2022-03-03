require 'AutoloadClasses'

local exec = function (str) vim.api.nvim_exec(str, false) end

-- Autoloads
--AutoCmd:new{ event = 'VimEnter', nested = true, cmd = 'colorscheme gruvbox' }:add()
--AutoCmd:new{ event = 'VimEnter', cmd = 'hi clear FoldColumn' }:add()
--AutoCmd:new{ event = 'VimEnter', cmd = 'hi clear SignColumn' }:add()
--AutoCmd:new{ event = 'FocusGained', nested = true, cmd = 'rshada!'}:add()
--AutoCmd:new{ event = 'FocusLost', nested = true, cmd = 'wshada!'}:add()
--AutoCmd:new{ event = 'VimEnter', nested = true, cmd = 'rshada!'}:add()
--AutoCmd:new{ event = 'VimLeave', nested = true, cmd = 'wshada!'}:add()

exec [[
augroup SHADA
    autocmd!
    autocmd CursorHold,TextYankPost,FocusGained,FocusLost *
        \ if exists(':rshada') | rshada | wshada | endif
augroup END
]]

