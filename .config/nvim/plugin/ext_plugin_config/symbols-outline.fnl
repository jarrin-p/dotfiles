(let [{: setup} (require :symbols-outline)
      settings {:highlight_hovered_item false
                :show_guides true
                :auto_preview false
                :position :left
                :relative_width true
                :width 25
                :auto_close false
                :show_numbers false
                :show_relative_numbers false
                :show_symbol_details true
                :preview_bg_highlight :Pmenu
                :autofold_depth 1
                :auto_unfold_hover true
                :fold_markers ["+" "-"]
                :wrap false
                :keymaps {;; These keymaps can be a string or a table for multiple keys
                          :close [:q]
                          :goto_location :<Cr>
                          :focus_location :<enter>
                          :hover_symbol :<leader>h
                          :toggle_preview :K
                          :rename_symbol :<leader>rn
                          :code_actions :gc
                          :fold [:h :zc]
                          :unfold [:l :zo]
                          :fold_all :zM
                          :unfold_all :zR
                          :fold_reset :zE}
                :lsp_blacklist {}
                :symbol_blacklist {}
                :symbols {:File {:icon :file :hl "@text.uri"}
                          :Module {:icon :module :hl "@namespace"}
                          :Namespace {:icon :namespace :hl "@namespace"}
                          :Package {:icon :package :hl "@namespace"}
                          :Class {:icon :class :hl "@type"}
                          :Method {:icon :method :hl "@method"}
                          :Property {:icon :property :hl "@method"}
                          :Field {:icon :field :hl "@field"}
                          :Constructor {:icon :constructor :hl "@constructor"}
                          :Enum {:icon :enum :hl "@type"}
                          :Interface {:icon :interface :hl "@type"}
                          :Function {:icon :function :hl "@function"}
                          :Variable {:icon :var :hl :Type}
                          :Constant {:icon :const :hl "@constant"}
                          :String {:icon :str :hl "@string"}
                          :Number {:icon :num :hl "@number"}
                          :Boolean {:icon :bool :hl "@boolean"}
                          :Array {:icon " " :hl "@constant"}
                          :Object {:icon :obj :hl "@type"}
                          :Key {:icon :key :hl "@type"}
                          :Null {:icon :NULL :hl "@type"}
                          :EnumMember {:icon :member :hl "@field"}
                          :Struct {:icon :struct :hl "@type"}
                          :Event {:icon :event :hl "@type"}
                          :Operator {:icon :operator :hl "@operator"}
                          :TypeParameter {:icon :type :hl "@parameter"}
                          :Component {:icon :component :hl "@function"}
                          :Fragment {:icon :fragment :hl "@constant"}}}]
  (setup settings))
{}
