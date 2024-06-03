(local {:nvim_create_autocmd autocmd} vim.api)
(local {: get-colorscheme-as-hex} (require :utils.color-tool))
(local {: format : transition} (require :pack.lines.util.component))
(local {: array-reversed : get-abs-path-as-table}
       (require :pack.lines.util.options))

(local {: right-align
        : left-tr
        : right-tr
        : bl
        : br
        :line-number line-number-symbol}
       (require :pack.lines.util.symbols))

;; names that get reused.
(local hl-group {:fill :LinesDefaultFill
              :header :LinesHeader
              :dir :LinesDirectory
              :ft :LinesFtInfo})

(let [{: concat} table
      {:nvim_set_hl set-hl :nvim_get_option_value get-opt} vim.api
      fg (get-colorscheme-as-hex :Fg :foreground)
      lighter (get-colorscheme-as-hex :Tabline :background)
      darker (get-colorscheme-as-hex :FloatBorder :background)
      line-number (.. line-number-symbol " %l:%L")
      column "col %c"
      buf-number "buf %n"]
  (fn build-statusline [opts]
    (let [header (or opts.filepath opts.buftype)
          dirs (or (format hl-group.dir (concat opts.dirs (.. " " bl " "))) "")
          tag-indicator (or opts.filetype opts.buftype)]
      (concat [(format hl-group.header)
               " "
               header
               opts.modified
               " "
               (transition hl-group.dir hl-group.header :background left-tr)
               bl
               " "
               (format hl-group.dir)
               dirs
               " "
               (format hl-group.fill)
               right-align
               (transition hl-group.fill hl-group.ft :background right-tr)
               (format hl-group.ft)
               " "
               tag-indicator
               " "
               br
               " "
               opts.line-number
               " "
               br
               " "
               opts.column
               " "
               br
               " "
               opts.buf-number
               " "] "")))

  ;; create the highlight groups
  (do
    (set-hl 0 hl-group.fill {:fg :Black :bg darker})
    (set-hl 0 hl-group.header {:fg :Black :bg fg})
    (set-hl 0 hl-group.dir {:italic 1
                         :fg (get-colorscheme-as-hex :Comment :foreground)
                         :bg darker})
    (set-hl 0 hl-group.ft {: fg :bg lighter})
    (set vim.g.LinesStatusBuild
         #(let [path (get-abs-path-as-table)
                head (table.remove path)
                modified (if (get-opt :modified {}) "+" "")
                directory-count 4
                reversed [(unpack (array-reversed path) 1 directory-count)]]
            (build-statusline {:filepath head
                               :dirs reversed
                               :filetype (get-opt :filetype {})
                               :buftype (get-opt :buftype {})
                               : modified
                               : line-number
                               : column
                               : buf-number})))
    (set vim.o.statusline "%{%g:LinesStatusBuild()%}")
    (autocmd [:VimEnter :WinEnter :BufWinEnter :WinNew :BufModifiedSet]
             {:callback vim.g.LinesStatusBuild})))

{}
; SetMakeRunner nvim --headless +"silent e utils.fnl" +"lua print(vim.g.LinesStatusBuild())" +"lua print(vim.g.MakeStatusLine())" +q
