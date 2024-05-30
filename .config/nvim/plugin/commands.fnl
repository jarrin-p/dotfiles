(let [{: file-format} (require :utils)
      exec vim.api.nvim_exec
      add-cmd vim.api.nvim_create_user_command
      set-font-size #(let [new-size (+ vim.g.font-size $1.args)]
                       (when (> new-size 0)
                         (do
                           (set vim.g.font-size new-size)
                           (set vim.o.guifont
                                (.. vim.g.FontKW vim.g.font_size "")))))]
  (exec "command! GT execute 'lcd' fnameescape(FugitiveWorkTree())" false)
  (add-cmd :FF file-format {})
  (add-cmd :GO #(exec "silent !tmux split-window -h -c $(dirname %)" false) {})
  (add-cmd :SetFontSize set-font-size)
  (let [update-makeprg (fn [args]
                         (let [cmd-prefix "tmux send-keys -t {marked} enter escape 'S"
                               cmd-post "' enter"
                               val args.args]
                           (set vim.o.makeprg (.. cmd-prefix val cmd-post))))]
    (add-cmd :SetMakeRunner update-makeprg {:nargs "?"})))

{}
