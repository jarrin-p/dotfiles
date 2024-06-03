{:linear-search (fn [array item]
                  "returns the index of 'item' if it exists in 'array'."
                  (accumulate [index -1 i val (ipairs array)
                               &until (not= -1 index)]
                    (if (= item val) i index)))
 :get-if-set (fn [option symbol]
               "returns a symbol when an option is set."
               (if (= (vim.api.nvim_get_option_value option {}) true) symbol ""))
 :get-branch-text #(if (= (vim.fn.FugitiveIsGitDir) 1)
                       (.. " " (vim.fn.FugitiveHead))
                       "no repo")
 :get-abs-path-as-table #(let [path (vim.fn.expand "%:p")
                               trim-root (path:sub 1)]
                           (accumulate [path-tbl {} val (trim-root:gmatch "/[^/]*")]
                             (let [(item _) (val:gsub "/" "")]
                               (table.insert path-tbl item)
                               path-tbl)))}
