(set vim.o.tabstop 2)

(let [{: load-once} (require :utils.load-once)
      {: getline : indent} vim.fn]
  (do
    (load-once :lean
               #(let [lean (require :lean)]
                  (lean.setup {:ft {:nomodifiable {}}
                               :infoview {:autoopen false :width 20 :height 30}})))
    (vim.opt.indentkeys:prepend [:0=end])
    (set vim.g.IndentLean #(let [line-nr vim.v.lnum
                                 prev-line-nr (- line-nr 1)
                                 prev-line (getline prev-line-nr)
                                 prev-indent (indent prev-line-nr)
                                 tabstop vim.o.tabstop]
                             (if (or (prev-line:find "^ *section ?")
                                     (prev-line:find "^ *namespace ?")
                                     (prev-line:find :where$)
                                     (prev-line:find ":=$"))
                                 (+ prev-indent tabstop)
                                 (or (: (getline ".") :find " *end ?"))
                                 (- prev-indent tabstop)
                                 prev-indent)))
    (set vim.bo.indentexpr "g:IndentLean()")))

{}
