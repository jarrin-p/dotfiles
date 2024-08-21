(let [{: file-format} (require :utils)
      exec vim.api.nvim_exec
      add-cmd vim.api.nvim_create_user_command
      set-font-size #(let [new-size (+ vim.g.font-size $1.args)]
                       (when (> new-size 0)
                         (do
                           (set vim.g.font-size new-size)
                           (set vim.o.guifont
                                (.. vim.g.FontKW vim.g.font_size "")))))]
  (add-cmd :FF file-format {})
  (add-cmd :GT #(let [path (-> (vim.fn.FugitiveWorkTree) (vim.fn.fnameescape))]
                  (vim.cmd.lcd path)) {})
  (add-cmd :GO #(exec "silent !tmux split-window -h -c $(dirname %)" false) {})
  (add-cmd :SetFontSize set-font-size {})
  (add-cmd :SetMakeRunner
           (fn [args]
             (let [cmd-prefix "tmux send-keys -t {marked} enter escape 'S"
                   cmd-post "' enter"
                   val args.args]
               (set vim.o.makeprg (.. cmd-prefix val cmd-post))))
           {:nargs "?"})
  ;; (add-cmd :ShowDiags #(let [
  ;;                            diags (vim.diagnostic.get)
  ;;                            buf (vim.api.nvim_create_buf true true)]
  ;;                        (do
  ;;                          (vim.cmd (.. "vsp +b" buf))
  ;;                          (icollect [i v (ipairs diags)] )
  ;;                          )) {})
  (add-cmd :ToggleInlayHints
           #(let [{: enable : is_enabled} vim.lsp.inlay_hint]
              (enable (not (is_enabled)))) {})
  )

{}
