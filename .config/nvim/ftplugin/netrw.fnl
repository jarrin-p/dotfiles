(let [util (require :util)]
  (set vim.wo.relativenumber true)
  (util.buf_nnoremap :<c-l> :<c-w>w)
  (util.buf_nnoremap :<c-h> :<c-w>W)
  (util.buf_nnoremap :dd :D) ; delete line (file, dir).
  (util.buf_nnoremap :cw :R) ; change word instead of replace.
  (util.buf_nnoremap :r :gn) ; make directory the [r]oot.
  (util.buf_nnoremap :R :<c-l>) ; [R]efresh the directory.
  (util.buf_nnoremap :bm :mb) ; [b]ook[m]ark
  )
{}
