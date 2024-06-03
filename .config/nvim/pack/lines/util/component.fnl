(local {: get-colorscheme-as-hex} (require :utils.color-tool))
(local {:nvim_set_hl set-hl} vim.api)

(fn format [highlight-group text]
  "alias for concatenation pattern in the status line."
  (.. "%#" highlight-group "#" (or text "")))

(fn transition [from-group to-group fg-or-bg transition-symbol]
  "
  transition from one highlight group to another highlight group, using
  the specified symbol.

  from-group          highlight group of starting transition
  to-group            highlight group of ending transition
  fg-or-bg            should be 'background' or 'foreground' for whatever reason.
  transition-symbol   the character that will act as the transition. probably a powerline symbol.

  returns a string with a transition formatted for the [status | tab]line.
  "
  (let [bg (get-colorscheme-as-hex from-group fg-or-bg)
        fg (get-colorscheme-as-hex to-group fg-or-bg)
        new-group-name (.. from-group :To to-group)]
    (do
      ;; todo (performance)
      ;; check if new-group-name exists, then do the logic.
      (set-hl 0 new-group-name {: bg : fg})
      (format new-group-name transition-symbol))))

(fn reversed [highlight-group-name supplied-name]
  "
  reverses the background and foreground colors, and creates a highlight group
  with 'Reverse' appended to the highlight group unless otherwise specified.

  highlight-group-name: string     highlight group to reverse.
  supplied-name: optional string   name to use for the color group instead of the generated one.
  "
  (let [new-bg (get-colorscheme-as-hex highlight-group-name :background)
        new-fg (get-colorscheme-as-hex highlight-group-name :foreground)
        output-highlight-group-name (case supplied-name
                                      nil (.. highlight-group-name :Reversed)
                                      x x)]
    (do
      (set-hl 0 output-highlight-group-name {:fg new-bg :bg new-fg})
      output-highlight-group-name)))

{: transition : reversed : format}
;; todo:
;; lua print current status line to grab format.
;; just define status line as part of an array in fennel
;; then concat.
