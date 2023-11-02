(let [util (require :util)
      exec util.exec
      add-cmd vim.api.nvim_create_user_command]
  (exec "command! GT execute 'lcd' fnameescape(FugitiveWorkTree())" false)
  (add-cmd :LG util.load_session_from_git_root {})
  (add-cmd :FF util.file_format {})
  (add-cmd :GO (fn [] (exec "silent !tmux split-window -h -c $(dirname %)")) {})
  (let [update-makeprg (fn [args]
                         (let [cmd-prefix "tmux send-keys -t {marked} escape 'S"
                               cmd-post "' enter"
                               val args.args]
                           (set vim.o.makeprg (.. cmd-prefix val cmd-post))))]
    (add-cmd :SetTest update-makeprg {:nargs "?"})))

{}
