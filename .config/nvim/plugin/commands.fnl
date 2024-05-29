(let [{ : file-format} (require :utils)
      exec vim.api.nvim_exec
      add-cmd vim.api.nvim_create_user_command]
  (exec "command! GT execute 'lcd' fnameescape(FugitiveWorkTree())" false)
  (add-cmd :FF file-format {})
  (add-cmd :GO #(exec "silent !tmux split-window -h -c $(dirname %)" false) {})
  (let [update-makeprg (fn [args]
                         (let [cmd-prefix "tmux send-keys -t {marked} enter escape 'S"
                               cmd-post "' enter"
                               val args.args]
                           (set vim.o.makeprg (.. cmd-prefix val cmd-post))))]
    (add-cmd :SetMakeRunner update-makeprg {:nargs "?"})))

{}
