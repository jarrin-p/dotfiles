(let [{: setup} (require :nvim-tree)
      config {:sync_root_with_cwd false
              :respect_buf_cwd false
              :view {:relativenumber true :width 50}
              :update_focused_file {:enable true
                                    :update_root true
                                    :ignore_list {}}
              :diagnostics {:enable true
                            :show_on_dirs true
                            :show_on_open_dirs true
                            :debounce_delay 50
                            :severity {:min vim.diagnostic.severity.HINT
                                       :max vim.diagnostic.severity.ERROR}
                            :icons {:hint :h :info :i :warning :w :error :x}}
              :renderer {:add_trailing false
                         :group_empty true
                         :highlight_git true
                         :full_name false
                         :highlight_opened_files :name
                         ;; :highlight_modified  "name"
                         ;; :root_folder_label  ":~:s?$?/..?"
                         :indent_width 2
                         :indent_markers {:enable false
                                          :inline_arrows true
                                          :icons {:corner "└"
                                                  :edge "│"
                                                  :item "│"
                                                  :bottom "─"
                                                  :none " "}}
                         :icons {:webdev_colors true
                                 :git_placement :after
                                 ;; :modified_placement  "before"
                                 :padding " "
                                 :symlink_arrow " ➛ "
                                 ;; :show  { :file  true :folder  true :folder_arrow  true :git  true }
                                 :show {:file true
                                        :folder true
                                        :folder_arrow true
                                        :git true
                                        :modified true}
                                 :glyphs {:default ""
                                          :symlink ""
                                          :bookmark ""
                                          ;; :modified  "*"
                                          :folder {:arrow_closed "▸"
                                                   :arrow_open "▾"
                                                   :default ""
                                                   :open ""
                                                   :empty ""
                                                   :empty_open ""
                                                   :symlink ""
                                                   :symlink_open ""}
                                          :git {:unstaged :u
                                                :staged :s
                                                :unmerged ""
                                                :renamed :r
                                                :untracked ""
                                                :deleted ""
                                                :ignored ""}}}
                         :special_files [:Cargo.toml
                                         :Makefile
                                         :README.md
                                         :readme.md]
                         :symlink_destination true}}]
  (setup config))
{}
