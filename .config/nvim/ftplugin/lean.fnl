(set vim.o.tabstop 2)
(local {: getline : indent} vim.fn)
(local patterns {:section "^ *section ?"
                 :namespace "^ *namespace ?"
                 :end "^ *end ?"})

(fn matching-indent [lnum]
  "returns an indent level for matched key words."
  (let [line (getline lnum)]
    (if (or (line:find patterns.section) (line:find patterns.namespace))
        (indent lnum) (line:find patterns.end) (- (indent lnum) vim.o.tabstop)
        (= lnum 1) -1 (matching-indent (- lnum 1)))))

(let [{: load-once} (require :utils.load-once)]
  (do
    (load-once :lean
               #(let [lean (require :lean)]
                  (lean.setup {:ft {:nomodifiable {}}
                               :infoview {:autoopen false :width 20 :height 30}})))
    (vim.opt.indentkeys:prepend [:0=end])
    (set vim.g.IndentLean #(let [line-nr vim.v.lnum
                                 current-line (getline line-nr)
                                 prev-line-nr (- line-nr 1)
                                 prev-line (getline prev-line-nr)
                                 prev-indent (indent prev-line-nr)
                                 tabstop vim.o.tabstop]
                             (if (or (prev-line:find patterns.section)
                                     (prev-line:find patterns.namespace)
                                     (prev-line:find :where$)
                                     (prev-line:find ":=$"))
                                 (+ prev-indent tabstop)
                                 (or (current-line:find patterns.end))
                                 (matching-indent prev-line-nr)
                                 prev-indent)))
    (set vim.bo.indentexpr "g:IndentLean()")))

{}