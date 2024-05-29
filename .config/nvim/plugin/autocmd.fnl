(let [au (fn [events opts] (_G.vim.api.nvim_create_autocmd events opts))]
  (au [:BufWinLeave]
      {:pattern [".*" "*"]
       :command "if expand(\"%\") != \"\" | silent! mkview | endif"})
  (au [:BufWinEnter]
      {:pattern [".*" "*"]
       :command "if expand(\"%\") != \"\" | silent! loadview | endif"})
  (au [:BufWinEnter]
      {:pattern [:*.flinklog] :command "runtime! after/syntax/flinklog.lua"})
  (au [:BufWinEnter]
      {:pattern [:*.rangerconf]
       :command "runtime! after/syntax/rangerconf.lua"})
  (au [:BufWinEnter]
      {:pattern [:*.lfrc]
       :command "runtime! after/syntax/lf.lua"})
  (au [:BufWinEnter]
      {:pattern [:*.velocity] :command "runtime! after/syntax/velocity.lua"})
)

; disables the cursorline on inactive splits.
; makes it more obvious which split is active.
(vim.cmd "augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END")
