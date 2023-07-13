(local build-session-command (fn [cmd path name] (.. cmd " " path "/" name)))

(local M {:map (fn [lhs rhs]
                 (vim.api.nvim_set_keymap "" lhs rhs
                                          {:noremap false :silent true}))
          :nnoremap (fn [lhs rhs]
                      (vim.api.nvim_set_keymap :n lhs rhs
                                               {:noremap true :silent true}))
          :buf_nnoremap (fn [lhs rhs]
                          (vim.api.nvim_set_keymap 0 :n lhs rhs
                                                   {:noremap true :silent true}))
          :inoremap (fn [lhs rhs]
                      (vim.api.nvim_set_keymap :i lhs (.. :<c-o> rhs)
                                               {:noremap true :silent true}))
          :tnoremap (fn [lhs rhs]
                      (vim.api.nvim_set_keymap :t lhs rhs
                                               {:noremap true :silent true}))
          :exec (fn [str send-output]
                  (vim.api.nvim_exec str
                                     (case send-output
                                       true
                                       true
                                       _
                                       false)))
          :make_session_on_git_root (lambda [?opts]
                                      (let [options (or ?opts {})
                                            session-name (or options.session_name
                                                             :Session.vim)
                                            file-path (or options.file_path
                                                          (vim.fn.FugitiveWorkTree))
                                            command (build-session-command :mksession!
                                                                           file-path
                                                                           session-name)]
                                        (print command)
                                        (vim.cmd command)))
          :load_session_from_git_root (lambda [?opts]
                                        (let [options (or ?opts {})
                                              session-name (or options.session_name
                                                               :Session.vim)
                                              file-path (or options.file_path
                                                            (vim.fn.FugitiveWorkTree))
                                              command (build-session-command :source
                                                                             file-path
                                                                             session-name)]
                                          (print command)
                                          (vim.cmd command)))})

; fennel exports the last value in a file.
M
