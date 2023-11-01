(let [buf_nnoremap (fn [lhs rhs]
                     (vim.api.nvim_buf_set_keymap 0 :n lhs rhs
                                                  {:noremap true :silent true}))]
  (buf_nnoremap :<c-l> :<c-w>w)
  (buf_nnoremap :<c-h> :<c-w>W)
  (buf_nnoremap :dd :D) ; delete line (file, dir).
  (buf_nnoremap :cw :R) ; change word instead of replace.
  (buf_nnoremap :r :gn) ; make directory the [r]oot.
  (buf_nnoremap :R :<c-l>) ; [R]efresh the directory.
  (buf_nnoremap :bm :mb) ; [b]ook[m]ark
  )
(set vim.wo.relativenumber true)
{}
