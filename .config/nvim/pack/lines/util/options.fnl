(fn array-reversed-iter [array i]
  (let [i (- i 1)]
    (if (> i 0) (values i (. array i)) nil)))

{:array-reversed (fn [array]
                   "returns an iterator for the array from the end of the array moving towards index 1"
                   (let [out {}
                         initial-value (+ (length array) 1)]
                     (do
                       (each [_ v (values array-reversed-iter array
                                          initial-value)]
                         (table.insert out v))
                       out)))
 :linear-search (fn [array item]
                  "returns the index of 'item' if it exists in 'array', otherwise it returns -1"
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
                               (do
                                 (table.insert path-tbl item)
                                 path-tbl))))}
