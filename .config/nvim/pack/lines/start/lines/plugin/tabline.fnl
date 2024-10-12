(local {: get-branch-text} (require :pack.lines.util.options))
(local {: concat} table)

(local {: format : transition} (require :pack.lines.util.component))
(local {: tabpagenr : tabpagewinnr :win_getid win-getid : fnamemodify} vim.fn)
(local {:nvim_win_get_buf win-getbuff
        :nvim_buf_get_name buf-getname
        :nvim_set_hl set-hl
        :nvim_create_namespace create-ns} vim.api)
(local {: right-align : left-tr} (require :pack.lines.util.symbols))

(local hl-group {:normal :TablineNormal :fill :TablineFill :selected :TablineSelected})

(let [ns (create-ns :Lines/Tab)]
  (do
    (set-hl 0 hl-group.normal {:ctermbg 0 :ctermfg 8})
    (set-hl 0 hl-group.fill {:ctermbg 0 :ctermfg 8})
    (set-hl 0 hl-group.selected {:ctermbg 8 :ctermfg 0})))

(fn tab-iter [total-tabs i]
  (let [i (+ i 1)]
    (if (< i (+ total-tabs 1))
        i
        nil)))

(fn tabs-iter []
  (values tab-iter (tabpagenr "$") 0))

;; see vim.diagnostic.Severity
(local sev-map
       (let [{: ERROR : WARN : INFO : HINT} vim.diagnostic.severity]
         {ERROR :errors WARN :warnings INFO :info HINT :hints}))

(do
  (set vim.g.LinesMakeTabline #(let [diags (accumulate [init {} _ v (ipairs (vim.diagnostic.get))]
                                             (do
                                               (tset init v.severity 1)
                                               init))
                                     lsp-diag-result (accumulate [init "" severity _ (pairs diags)]
                                                       (.. init " "
                                                           (tostring (. sev-map
                                                                        severity))))
                                     selected (tabpagenr)
                                     tabs (icollect [i (tabs-iter)]
                                            (let [highlight (if (= i selected)
                                                                hl-group.selected
                                                                hl-group.normal)
                                                  buf-name (-> (tabpagewinnr i)
                                                               (win-getid i)
                                                               (win-getbuff)
                                                               (buf-getname)
                                                               (fnamemodify ":t"))]
                                              (concat [(format highlight)
                                                       " "
                                                       i
                                                       " "
                                                       buf-name
                                                       " "]
                                                      "")))]
                                 (concat [(format hl-group.normal)
                                          " "
                                          (get-branch-text)
                                          " "
                                          ;; (transition hl-group.fill
                                          ;;             hl-group.normal
                                          ;;             :background left-tr)
                                          (format hl-group.fill)
                                          lsp-diag-result
                                          " "
                                          right-align
                                          " "
                                          (concat tabs)]
                                         "")))
  (vim.api.nvim_create_autocmd [:InsertLeave] {:callback vim.g.LinesMakeTabline})
  (vim.cmd "set tabline=%!LinesMakeTabline()"))

{}
; SetMakeRunner nvim --headless +"silent e utils.fnl" +"lua print(vim.g.MakeTabline())" +"lua print(vim.g.LinesMakeTabline())" +q
