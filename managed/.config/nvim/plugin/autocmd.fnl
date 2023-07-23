(local util (require :utils))

(let [au (fn [events opts] (_G.vim.api.nvim_create_autocmd events opts))]
  (au [:BufWritePost]
      {:pattern [".*" "*"] :callback util.clean_buffer_postspace})
  (au [:BufWritePost]
      {:pattern [".*" "*"] :callback util.make_session_on_git_root})
  (au [:BufWinLeave]
      {:pattern [".*" "*"]
       :command "if expand(\"%\") != \"\" | silent! mkview | endif"})
  (au [:BufWinEnter]
      {:pattern [".*" "*"]
       :command "if expand(\"%\") != \"\" | silent! loadview | endif"})
  (au [:DirChanged :VimLeave] {:callback util.export_cwd})
  (au [:BufWinEnter]
      {:pattern [:*.flinklog] :command "runtime! after/syntax/flinklog.lua"})
  (au [:BufWinEnter]
      {:pattern [:*.rangerconf]
       :command "runtime! after/syntax/rangerconf.lua"})
  (au [:BufWinEnter]
      {:pattern [:*.velocity] :command "runtime! after/syntax/velocity.lua"})
)
(vim.cmd "augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END")
