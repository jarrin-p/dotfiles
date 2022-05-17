require 'AutoloadClasses'

-- open nerdtree as soon as vim opens.
-- and turn relative number on. it makes navigating the tree even easier.
AutoCmd:new{event = 'VimEnter', cmd = 'NERDTreeToggleVCS'}:add()
AutoCmd:new{event = 'VimEnter', cmd = 'set relativenumber'}:add()

-- wonky way of checking if nvim opened a buffer.
-- basically if the starting buffer isn't empty, stay to it, otherwise
-- full-size nerdtree.
AutoCmd:new{event = 'VimEnter', cmd = 'wincmd w'}:add()
AutoCmd:new{event = 'VimEnter', cmd = 'echo &filetype'}:add()
AutoCmd:new{event = 'VimEnter', cmd = 'if line("$") == 1 && getline(1) == "" | wincmd p | only | endif'}:add()

-- match spotlessApply in main project.
AutoCmd:new{event = 'FileType', pattern='java', cmd = 'set tabstop=2'}:add()

-- keep manual folds.
AutoCmd:new{event = 'BufWritePost', pattern='*.*', cmd = 'mkview'}:add()
AutoCmd:new{event = 'BufWinEnter', pattern='*', cmd = 'silent! loadview'}:add()

-- custom spotlessApply command (SA) that runs at top of git level.
-- assumes java is using gradle with SA ipmlemented.
AutoCmd:new{event = 'BufWritePost', pattern='*.java', cmd = 'silent SA'}:add()

-- groups not implemented yet, using standard vimscript for shada share.
 local exec = function (str) vim.api.nvim_exec(str, false) end

 -- share shada (registers, etc) between windows.
 -- useful when using terminal splits or tiled windows.
 -- note: no longer using after adding 'unnamed,unnamedplus' to clipboard setting
 -- keeping code just in case
 -- exec [[
 -- augroup SHADA
 --     autocmd!
 --     autocmd CursorHold,TextYankPost,FocusGained,FocusLost *
 --         \ if exists(':rshada') | rshada | wshada | endif
 -- augroup END
 -- ]]
