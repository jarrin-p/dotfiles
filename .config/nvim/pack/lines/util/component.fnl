(fn format [highlight-group]
  (.. "%#" highlight-group "#"))

(fn transition [from-group to-group fg-or-bg transition-symbol]
  "transition from one highlight group to another highlight group, using
  the specified symbol.

  from-group          highlight group of starting transition
  to-group            highlight group of ending transition
  fg-or-bg            should be 'background' or 'foreground' for whatever reason.
  transition-symbol   the character that will act as the transition. probably a powerline symbol.

  returns a string with a transition formatted for the [status | tab]line.
  "
  (let [{: get-colorscheme-as-hex} (require :utils.color-tool)
        bg (get-colorscheme-as-hex from-group fg-or-bg)
        fg (get-colorscheme-as-hex to-group fg-or-bg)
        new-group-name (.. from-group :To to-group)]
    (do
      ;; todo (performance)
      ;; check if new-group-name exists, then do the logic.
      (vim.api.nvim_set_hl 0 new-group-name {: bg : fg})
      (.. (format new-group-name) transition-symbol))))

{: transition}
;; todo:
;; lua print current status line to grab format.
;; just define status line as part of an array in fennel
;; then concat.
