; @author jarrin-p
; @file `settings.fnl`
(set vim.o.compatible false)

; shada settings
; @see "h 'sd'" or "h 'shada'"
(let [shada-settings (table.concat ["%3" "'10" "\"50" :s10 ":50" :h] ",")]
  (set vim.o.shada shada-settings))

; gui settings
(set vim.g.font_size 15)
(set vim.g.FontKW (.. "JetBrains Mono:h" vim.g.font_size ", Fira Code:h"))
(set vim.o.guifont (.. vim.g.FontKW vim.g.font_size ""))
(set vim.o.linespace 12)

;; sets the font size using a controlled global variable. allows easy remapping for increasing and decreasing
;; font size, something very much appreciated by others when screen sharing.
(global SetFontSize
        (fn [amt]
          (let [delta (+ vim.g.font_size amt)]
            (if (> delta 0)
                (set vim.g.font_size delta)
                (set vim.o.guifont (.. vim.g.FontKW vim.g.font_size ""))))))

(set vim.o.title true)
(set vim.o.titlestring "%t")
(set vim.o.showtabline 2)

;; always show the tabline
(set vim.o.tabstop 4)

;; 0 means use tabstop value
(set vim.o.shiftwidth 0)

;; use spaces instead of tabs.
(set vim.o.expandtab true)

;; trying out only autoindent.
(set vim.o.smartindent false)

(set vim.o.wrap false)
(set vim.o.number true)
(set vim.o.relativenumber true)

;; show how many lines away instead of exact line number.
(set vim.o.syntax :on)
(set vim.o.foldcolumn :3)
(set vim.o.foldmethod :manual)
(set vim.o.path (.. vim.o.path "**"))
(set vim.o.signcolumn :yes)
(set vim.o.updatetime 25)
(set vim.o.foldlevelstart 99)
(set vim.o.scrolloff 2)

;; a little padding for the top and bottom of screen.
(set vim.o.cursorline true)
(set vim.o.textwidth 0)
(set vim.o.showmode true)

;; specifically defining as true for whatever reason.
(set vim.o.splitright true)

;; splits new window to the right.
(set vim.o.splitbelow true)

;; splits new window down.
(set vim.o.list true)
(set vim.o.listchars "tab:;>,leadmultispace:    ,trail:-")
(set vim.o.jumpoptions :view)
(vim.opt_global.shortmess:remove :F)

;; used for `nvim metals`
(set vim.o.mouse :nv)
(set vim.o.termguicolors true)
(set vim.o.viewoptions "folds,cursor")

;; editing settings
(set vim.o.backspace "indent,eol,start")
(set vim.o.magic true)
(set vim.o.spell false)
(set vim.o.inccommand :split)
(set vim.o.completeopt "menu,menuone,preview,noselect")
(set vim.o.ignorecase false)
(set vim.o.smartcase true)
(set vim.o.clipboard "unnamed,unnamedplus")
(set vim.o.autowrite true)
(set vim.o.hidden false)

;; builtin plugin settings.
(set vim.g.netrw_liststyle 3)
(set vim.g.csv_nomap_cr 1)

;; term settings
(set vim.o.ttimeoutlen 0)

;; lsp settings
(vim.lsp.inlay_hint.enable true)

;; grep pattern setup
(let [patterns {:!*.class :!*.jar :!*.java.html :!*.git*}
      pattern-string (accumulate [init "" _ pattern (ipairs patterns)]
                       (.. init " --glob='" pattern "'"))
      rg-string "rg --line-number --with-filename"]
  (set vim.o.grepprg (.. rg-string pattern-string)))

{}
