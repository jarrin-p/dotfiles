(set vim.o.tabstop 2)
(local {: getline : indent} vim.fn)
(local patterns {:section "^ *section ?"
                 :namespace "^ *namespace ?"
                 :end "^ *end ?"})

(fn matching-indent [lnum]
  "returns an indent level for matched key words."
  (let [line (getline lnum)]
    (if (or (line:find patterns.section) (line:find patterns.namespace))
        (indent lnum)
        (line:find patterns.end)
        (- (indent lnum) vim.o.tabstop)
        (= lnum 1)
        -1
        (matching-indent (- lnum 1)))))

; see `https://github.com/Julian/lean.nvim/wiki/Configuring-&-Extending#semantic-highlighting`
(let [mappings {"@lsp.type.variable" :Identifier}]
  (do
    (each [from to (pairs mappings)]
      (vim.cmd.highlight (.. :link " " from " " to)))))

; todo: use something like this for inserting type annotations.
; `vim.lsp.buf_request_sync(0, "textDocument/hover", vim.lsp.util.make_position_params(), 1000)`
; ideally, this could be implemented as a code action, but if the language server doesn't support it,
; it might be easier to just make something jank.
;; (let [{:buf_request buf-request : util} vim.lsp
;;       {:make_position_params pos-params} util]
;;   (-> (buf-request :textDocument/hover (pos-params))
;;       (. :results :contents :value)
;;       ; modify the resulting string...
;;       ))

(let [{: load-once} (require :utils.load-once)]
  (do
    (load-once :lean
               #(let [lean (require :lean)]
                  (lean.setup {:ft {:nomodifiable {}}
                               :infoview {:autoopen false
                                          :width 100
                                          :height 300}})))
    (vim.opt_local.indentkeys:prepend [:0=end])
    (set vim.g.IndentLean #(let [line-nr vim.v.lnum
                                 current-line (getline line-nr)
                                 prev-line-nr (- line-nr 1)
                                 prev-line (getline prev-line-nr)
                                 prev-indent (indent prev-line-nr)
                                 tabstop vim.o.tabstop]
                             (if (or (prev-line:find patterns.section)
                                     (prev-line:find patterns.namespace)
                                     (prev-line:find :where$)
                                     (prev-line:find :with$)
                                     (prev-line:find "=>$")
                                     (prev-line:find :calc$)
                                     (prev-line:find ":=$"))
                                 (+ prev-indent tabstop)
                                 (or (current-line:find patterns.end))
                                 (matching-indent prev-line-nr)
                                 prev-indent)))
    (set vim.bo.indentexpr "g:IndentLean()")))

{}
