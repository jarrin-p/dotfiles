(fn build-session-command [cmd path name] (.. cmd " " path "/" name))
{:map (fn [lhs rhs]
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
                                            command (build-session-command "silent! mksession!"
                                                                           file-path
                                                                           session-name)]
                                        (vim.cmd command)))
          ; unused
          :backup_session (lambda [?opts]
                            (let [options (or ?opts {})
                                  session-name (or options.session_name
                                                   :Session.vim)
                                  file-path (or options.file_path
                                                (:/tmp/current_session))
                                  command (build-session-command "silent! mksession!"
                                                                 file-path
                                                                 session-name)]
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
                                          (vim.cmd command)))
          :clean_buffer_postspace 
                                    #(let [view (vim.fn.winsaveview)]
                                      (vim.cmd "keepjumps silent %smagic/ *$//")
                                      (vim.fn.winrestview view))
          :get_listed_bufnames 
                                 #(let [buf-info (vim.fn.getbufinfo)
                                       cleanup (fn [buffer]
                                                 (vim.fn.fnamemodify buffer.name
                                                                     ":~:."))
                                       buffer-names (icollect [_ buffer (ipairs buf-info)]
                                                      (if (and (= buffer.listed 1) (= buffer.hidden 0))
                                                          (cleanup buffer) nil))]
                                   buffer-names)
          :export_cwd #(os.execute (.. "echo \"" (vim.fn.getcwd) "\" > /tmp/.vim_cwd"))
          :string_to_table (fn [str delim]
                             (let [sanitized-str (.. str delim)]
                               (icollect [v (sanitized-str:gmatch (.. "([^"
                                                                      delim
                                                                      "]+)"))]
                                 v)))
          :file-format #(let [view (vim.fn.winsaveview)]
                           (do
                             (vim.cmd "keepjumps silent norm gggqG")
                             (vim.fn.winrestview view)))}
