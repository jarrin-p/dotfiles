; @author jarrin-p
; @file `settings.fnl`
(set vim.o.compatible false)

; shada settings
; @see "h 'sd'" or "h 'shada'"
(let [shada-settings (table.concat ["%3" "'10" "\"50" :s10 ":50" :h] ",")]
  (set vim.o.shada shada-settings))

(let [vim-settings {:g {:csv_nomap_cr 1 :netrw_liststyle 3}
                    :o {;;
                        ;;
                        ;; layout
                        :linespace 12
                        :path (.. vim.o.path "**")
                        :showtabline 2
                        :termguicolors true
                        :title true
                        :titlestring "%t"
                        ;;
                        ;;
                        ;; visual behavior (doesn't effect document)
                        :completeopt "menu,menuone,preview,noselect"
                        :cursorline true
                        :foldcolumn :3
                        :foldlevelstart 99
                        :foldmethod :manual
                        :ignorecase false
                        :inccommand :split
                        :jumpoptions :view
                        :list true
                        :listchars "tab:;>,leadmultispace:    ,trail:-"
                        :mouse :nv
                        :number true
                        :relativenumber true
                        :scrolloff 2
                        :showmode true
                        :signcolumn :yes
                        :smartcase true
                        :spell false
                        :splitbelow true
                        :splitright true
                        :syntax :on
                        :textwidth 0
                        :updatetime 25
                        :viewoptions "folds,cursor"
                        :wrap false
                        ;;
                        ;;
                        ;; editing behavior (effects document)
                        :autoindent false
                        :autowrite true
                        :backspace "indent,start"
                        :clipboard "unnamed,unnamedplus"
                        :expandtab true
                        :hidden false
                        :magic true
                        :shiftwidth 0
                        :smartindent false
                        :tabstop 4
                        ;;
                        ;;
                        ;; plugin settings.
                        :ttimeoutlen 0
                        ;;
                        ;;
                        ;; settings for external programs
                        :grepprg "rg --vimgrep"}}]
  (each [opt-type opts (pairs vim-settings)]
    (each [opt value (pairs opts)]
      (tset vim opt-type opt value))))

;; settings that have to be toggled.
(do
  (vim.opt_global.shortmess:remove :F)
  (vim.lsp.inlay_hint.enable true))

{}
