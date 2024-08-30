;; (let [{: setup} (require :symbols-outline)
;;       settings {:highlight_hovered_item false
;;                 :show_guides true
;;                 :auto_preview false
;;                 :position :left
;;                 :relative_width true
;;                 :width 25
;;                 :auto_close false
;;                 :show_numbers false
;;                 :show_relative_numbers false
;;                 :show_symbol_details true
;;                 :preview_bg_highlight :Pmenu
;;                 :autofold_depth 1
;;                 :auto_unfold_hover true
;;                 :fold_markers ["+" "-"]
;;                 :wrap false
;;                 :keymaps {;; These keymaps can be a string or a table for multiple keys
;;                           :close [:q]
;;                           :goto_location :<Cr>
;;                           :focus_location :<enter>
;;                           :hover_symbol :<leader>h
;;                           :toggle_preview :K
;;                           :rename_symbol :<leader>rn
;;                           :code_actions :gc
;;                           :fold [:h :zc]
;;                           :unfold [:l :zo]
;;                           :fold_all :zM
;;                           :unfold_all :zR
;;                           :fold_reset :zE}
;;                 :lsp_blacklist {}
;;                 :symbol_blacklist {}
;;                 }]
;;   (setup settings))
;; {}
