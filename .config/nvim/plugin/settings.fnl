(let [vim-settings {:g {:clipboard (if (and (= 1 (vim.fn.executable :clip.exe))
                                            (= 1
                                               (vim.fn.executable :powershell.exe)))
                                       {:name :windows-clip
                                        :copy {:+ [:clip.exe] :* [:clip.exe]}
                                        :paste {:+ "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"`r\", \"\"))"
                                                :* "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"`r\", \"\"))"}}
                                       false)
                        :csv_nomap_cr 1
                        :netrw_liststyle 3}
                    :o {:compatible false
                        ;;
                        ;;
                        ;; layout
                        :linespace 12
                        :path (.. vim.o.path "**")
                        :showtabline 2
                        :termguicolors false
                        :title true
                        :titlestring "%t"
                        ;;
                        ;;
                        ;; visual behavior (doesn't effect document)
                        :cursorline true
                        :foldcolumn :3
                        :foldlevelstart 99
                        :foldmethod :manual
                        :ignorecase false
                        :inccommand :split
                        :jumpoptions :view
                        :laststatus 3
                        :list true
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
                        :wrap false
                        ;;
                        ;;
                        ;; editing behavior (effects document)
                        :autoindent false
                        :autowrite true
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
                        :grepprg "rg --vimgrep"}
                    ;; see `h vim.opt`
                    :opt {:backspace [:indent :start]
                          :clipboard [:unnamed :unnamedplus]
                          :completeopt [:menu :menuone :preview :noselect]
                          :listchars {:tab ";>"
                                      :leadmultispace "    "
                                      :trail "-"}
                          :shada ["%3" "'10" "\"50" :s10 ":50" :h]
                          :viewoptions [:folds :cursor]}}]
  (each [opt-type opts (pairs vim-settings)]
    (each [opt value (pairs opts)]
      (tset vim opt-type opt value))))

;; settings that have to be toggled.
(do
  (vim.opt_global.shortmess:remove :F)
  (vim.lsp.inlay_hint.enable true))

{}
