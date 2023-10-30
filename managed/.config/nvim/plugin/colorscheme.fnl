(local util (require :pack.statusline.util.util))
(local apply_opacity (. (require :hex_tool) :apply_opacity_transition))

(local fg (util.get_colorscheme_as_hex :Fg :foreground))
(local bg (util.get_colorscheme_as_hex :Normal :background))
(local darker (util.get_colorscheme_as_hex :FloatBorder :background))

(local green (util.get_colorscheme_as_hex :Green :foreground))
(local red (util.get_colorscheme_as_hex :Red :foreground))
(local orange (util.get_colorscheme_as_hex :Orange :foreground))
;; local dark_green = "#252715"
;; local dark_red = "#251110"
;; local dark_orange = "#25160c"

(local opacity 0.15)
(local dark_green (apply_opacity green bg opacity))
(local dark_red (apply_opacity red bg opacity))
(local dark_orange (apply_opacity orange bg opacity))

(let [set-hl (fn [name opts] (vim.api.nvim_set_hl 0 name opts))]
  (set-hl :DiffAdd {:bg dark_green})
  (set-hl :DiffAdded {:link :DiffAdd})
  (set-hl :DiffDelete {:bg dark_red :fg dark_red})
  (set-hl :DiffRemoved {:bg dark_red})
  (set-hl :DiffChange {:bg dark_orange})
  (set-hl :DiffText {:bg dark_orange})
  (set-hl :EndOfBuffer {:fg :bg})
  (set-hl :Folded {:link :Comment })
  (set-hl :Search {:bg darker :underline true :italic true})
  (set-hl :CurSearch {:bg darker :underline true :italic true :bold true})
  (set-hl :String {:link :AquaItalic})
  (set-hl :MsgArea {: fg :bg darker})
  (set-hl :TablineFill {:link :Normal})
  (set-hl :Whitespace {:fg dark_orange}))
