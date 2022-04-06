require 'AutoloadClasses'

-- open nerdtree as soon as vim opens
AutoCmd:new{ event = 'VimEnter', cmd = 'NERDTreeToggleVCS' }:add()

-- ensure relative number is on. it makes navigating the tree even easier
AutoCmd:new{ event = 'VimEnter', cmd = 'set relativenumber' }:add()

-- switch to editing window
AutoCmd:new{ event = 'VimEnter', cmd = 'wincmd l' }:add()

--AutoCmd:new{ event = 'BufWritePost', pattern='*.java', cmd = '!gradle spotlessApply' }:add()
AutoCmd:new{ event = 'BufWritePost', pattern='*', cmd = 'mks! .session.vim' }:add()
--AutoCmd:new{ event = 'BufEnter', pattern = '*', nested = false, cmd = 'lcd %:p:h'}:add()

-- groups not implemented yet, using standard vimscript for shada share
-- local exec = function (str) vim.api.nvim_exec(str, false) end

-- -- share shada (registers, etc) between windows.
-- exec [[
-- augroup SHADA
--     autocmd!
--     autocmd CursorHold,TextYankPost,FocusGained,FocusLost *
--         \ if exists(':rshada') | rshada | wshada | endif
-- augroup END
-- ]]

