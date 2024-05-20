(let [{:get_colorscheme_as_hex colorscheme-as-hex} (require :pack.statusline.util.util)
      {: apply-opacity-transition} (require :hex-tool)]
  ;; local dark_green = "#252715"
  ;; local dark_red = "#251110"
  ;; local dark_orange = "#25160c"
  (let [set-hl (fn [name opts] (vim.api.nvim_set_hl 0 name opts))
        opacity 0.15
        fg (colorscheme-as-hex :Fg :foreground)
        bg (colorscheme-as-hex :Normal :background)
        darker (colorscheme-as-hex :FloatBorder :background)
        green (colorscheme-as-hex :Green :foreground)
        red (colorscheme-as-hex :Red :foreground)
        orange (colorscheme-as-hex :Orange :foreground)
        dark_green (apply-opacity-transition green bg opacity)
        dark_red (apply-opacity-transition red bg opacity)
        dark_orange (apply-opacity-transition orange bg opacity)]
    (set-hl :DiffAdd {:bg dark_green})
    (set-hl :DiffAdded {:link :DiffAdd})
    (set-hl :DiffDelete {:bg dark_red :fg dark_red})
    (set-hl :DiffRemoved {:bg dark_red})
    (set-hl :DiffChange {:bg dark_orange})
    (set-hl :DiffText {:bg dark_orange})
    (set-hl :EndOfBuffer {:fg :bg})
    (set-hl :Folded {:link :Comment})
    (set-hl :Search {:bg darker :underline true :italic true})
    (set-hl :CurSearch {:bg darker :underline true :italic true :bold true})
    (set-hl :String {:link :AquaItalic})
    (set-hl :MsgArea {: fg :bg darker})
    (set-hl :TablineFill {:link :Normal})
    (set-hl :Whitespace {:fg dark_orange})))
