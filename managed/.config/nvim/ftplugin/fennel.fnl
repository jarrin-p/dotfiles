(vim.api.nvim_create_user_command :FF
                                  (fn [_]
                                    (_G.vim.cmd :w)
                                    (_G.vim.cmd "!fnlfmt --fix %"))
                                  {})
