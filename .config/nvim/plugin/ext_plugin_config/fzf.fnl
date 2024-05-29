(fn fzf [opts]
  (let [{"fzf#run" run "fzf#wrap" wrap} vim.fn]
    (run (wrap opts))))

(fn set-branch-to-diff []
  (let [branch (vim.fn.input "enter branch to diff against: ")]
    (do
      (set vim.g.BranchToDiff branch)
      branch)))

(let [{:string_to_table string-to-table
       :get_listed_bufnames get-listed-bufnames} (require :utils)
      new-cmd #(vim.api.nvim_create_user_command $1 $2 {})
      join #(table.concat $1 " ")]
  (new-cmd :FuzzyBranchChanges
           #(let [to-diff (case vim.g.BranchToDiff
                            nil (set-branch-to-diff)
                            branch branch)
                  source (.. "git diff " to-diff " --name-only")]
              (fzf {: source
                    :sink #((vim.cmd :GT) (vim.cmd (.. "e " $1)))
                    :options (.. "--prompt \"(" to-diff ") changed file > \"")})))
  (new-cmd :FuzzyBranchChangesSetBranch #(set-branch-to-diff))
  (new-cmd :FuzzyBranchSelect
           #(fzf {:source "git branch --no-color | tr -d \" \" | sort -r -"
                  :sink #(when (not= ($1:find "*") 1)
                           (vim.cmd (.. "G checkout " $1)))
                  :options "--prompt \"branch name > \""}))
  (new-cmd :FuzzyBufferSelect
           #(fzf {:source (get-listed-bufnames)
                  :sink #(vim.cmd (.. "e " $1))
                  :options (.. "--prompt \"buffer name > \"")}))
  (new-cmd :FuzzyFindNoIgnore
           #(fzf {:source "rg --no-ignore --hidden --files --glob='!*.git'"
                  :sink #(vim.cmd (.. "e " $1))}))
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
                    :sink #(let [[file-path row col] (string-to-table $1 ":")]
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
                                    "--header 'ctrl-f to switch to fzf for additional filtering'"])}))))

{}
