require 'AutoloadClasses'

-- open nerdtree as soon as vim opens
-- and turn relative number on. it makes navigating the tree even easier
AutoCmd:new{ event = 'VimEnter', cmd = 'NERDTreeToggleVCS' }:add()
AutoCmd:new{ event = 'VimEnter', cmd = 'set relativenumber' }:add()

-- switch to editing window
-- TODO conditional switch to editing window
--AutoCmd:new{ event = 'VimEnter', cmd = 'wincmd l' }:add()

-- match spotlessApply in main project
AutoCmd:new{ event = 'FileType', pattern='java', cmd = 'set tabstop=2' }:add()

-- keep manual folds
AutoCmd:new{ event = 'BufWritePost', pattern='*.*', cmd = 'mkview' }:add()
AutoCmd:new{ event = 'BufWinEnter', pattern='*', cmd = 'silent! loadview'}:add()

-- custom spotlessApply command (SA) that runs at top of git level.
-- assumes java is using gradle. reloads all buffers afterwards
-- TODO add check
AutoCmd:new{ event = 'BufWritePost', pattern='*.java', cmd = 'silent SA' }:add()
AutoCmd:new{ event = 'BufWritePost', pattern='*.java', cmd = 'set noconfirm' }:add()
AutoCmd:new{ event = 'BufWritePost', pattern='*.java', cmd = 'silent e' }:add()
AutoCmd:new{ event = 'BufWritePost', pattern='*.java', cmd = 'set confirm' }:add()

-- auto cd to path in vim
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

