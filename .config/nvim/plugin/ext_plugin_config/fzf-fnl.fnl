(fn fzf [opts]
  (let [{"fzf#run" run "fzf#wrap" wrap} vim.fn]
    (run (wrap opts))))

(let [{:string_to_table string-to-table
       :get_listed_bufnames get-listed-bufnames} (require :utils)
      new-cmd vim.api.nvim_create_user_command
      join #(table.concat $1 " ")]
  (new-cmd :FuzzyGrep
           #(let [prefix (join [:rg
                                :--hidden
                                :--column
                                :--line-number
                                :--no-heading
                                :--color=always
                                :--smart-case
                                "--glob='!*.git'"
                                " "])]
              (fzf {:source (.. prefix "\"\"")
                    :sink #(let [{1 file-path 2 row 3 col} (string-to-table $1
                                                                            ":")]
                             (vim.cmd (.. "e " file-path))
                             (vim.fn.cursor row col))
                    :options (join [:--ansi
                                    "--prompt 'grep > '"
                                    :--disabled
                                    "--query \"\""
                                    "--delimiter :"
                                    (.. "--bind \"change:reload:sleep 0.1; "
                                        prefix " {q} || true\"")
                                    "--bind 'ctrl-f:unbind(change,ctrl-f)+change-prompt(fzf > )+enable-search+clear-query'"
                                    "--header 'ctrl-f to switch to fzf for additional filtering'"])}))
           {}))

{}
