(let [{:nvim_set_keymap set-keymap} vim.api
      ;; see nvim_set_keymap docs, empty string in position 2 implies noop so callback can be passed
      nnoremap-cb #(set-keymap :n $1 ""
                               {:noremap true :silent true :callback $2})]
  (do
    ;; general keymaps
    (set-keymap "" :<space> :<leader> {:noremap false :silent true})
    (set-keymap :n :Y :y$ {:noremap true :silent true})
    (set-keymap :n :U :<c-r> {:noremap true :silent true}) ; change U to redo because I'm simple and U confuses me.
    (set-keymap :n "`" "'" {:noremap true :silent true}) ; swap mapping of "jump to mark's col,line" with "jump to mark's line".
    (set-keymap :n "'" "`" {:noremap true :silent true}) ; swap mapping of "jump to mark's line" with "jump to mark's col,line".
    (set-keymap :n :<c-h> :<c-w>W {:noremap true :silent true}) ; previous window (above, left)
    (set-keymap :n :<c-l> :<c-w>w {:noremap true :silent true})
    ;;
    ;; terminal remaps
    ;;
    (set-keymap :t "<C-[>" "<C-\\><C-n>" {:noremap true :silent true})
    (set-keymap :t :<c-h> "<C-\\><C-n><c-w>W" {:noremap true :silent true})
    (set-keymap :t :<c-l> "<C-\\><C-n><c-w>w" {:noremap true :silent true})
    ;;
    ;; gui maps
    ;;
    (nnoremap-cb :<leader>+ #(vim.cmd.SetFontSize 1)) ; increase or decrease respectively the font size via mapping.
    (nnoremap-cb :<leader>- #(vim.cmd.SetFontSize -1))
    ;;
    ;; buffer navigating
    ;;
    (nnoremap-cb "[B" #(vim.cmd.b "#"))
    (nnoremap-cb "[b" vim.cmd.bprev)
    (nnoremap-cb "]b" vim.cmd.bnext)
    (nnoremap-cb :<c-t> #(vim.cmd.tabedit "%"))
    (nnoremap-cb :<c-f> #(do
                           (vim.cmd.lcd "%:p:h")
                           (vim.cmd.pwd)))
    (nnoremap-cb :<c-g> #(do
                           (vim.cmd.GT)
                           (vim.cmd.pwd)))
    ;;
    ;; fold method changing
    ;;
    (nnoremap-cb :<leader>zfi #(set vim.o.foldmethod :indent))
    (nnoremap-cb :<leader>zfm #(set vim.o.foldmethod :manual))
    ;;
    ;; finding navigation
    ;;
    (nnoremap-cb "]c" vim.cmd.cnext)
    (nnoremap-cb "[c" vim.cmd.cprev)
    (nnoremap-cb "[t" vim.cmd.NvimTreeClose)
    (nnoremap-cb "]t" vim.cmd.NvimTreeOpen)
    (nnoremap-cb :<leader>T vim.cmd.NvimTreeFindFile)
    ;;
    ;; git
    ;;
    (nnoremap-cb :<leader>G #(vim.cmd "tab G"))
    ;;
    ;; fzf
    ;;
    (nnoremap-cb :<leader>f vim.cmd.FZF)
    (nnoremap-cb :<leader>F vim.cmd.FuzzyFindNoIgnore)
    (nnoremap-cb :<leader>g vim.cmd.FuzzyGrep)
    (nnoremap-cb :<leader>b vim.cmd.FuzzyBufferSelect)
    (nnoremap-cb :<leader>B vim.cmd.FuzzyBranchSelect)
    (nnoremap-cb :<leader>h vim.cmd.FuzzyBranchChanges)
    (nnoremap-cb :<leader>H vim.cmd.FuzzyBranchChangesSetBranch)
    (nnoremap-cb :g? vim.cmd.Maps)
    ;;
    ;; lsp
    ;;
    (nnoremap-cb :g= #(vim.lsp.buf.format {:async false}))
    (nnoremap-cb :gD vim.lsp.buf.declaration)
    (nnoremap-cb :gd vim.lsp.buf.definition)
    (nnoremap-cb :gi vim.lsp.buf.incoming_calls)
    (nnoremap-cb :<leader>d vim.lsp.buf.hover)
    (nnoremap-cb :gi vim.lsp.buf.incoming_calls)
    (nnoremap-cb :<leader>rn vim.lsp.buf.rename)
    (nnoremap-cb :gc vim.lsp.buf.code_action)
    (nnoremap-cb :gsw vim.lsp.buf.workspace_symbol) ; [s]ymbol [w]orkspace
    (nnoremap-cb :gsd vim.lsp.buf.document_symbol) ; [s]ymbol [d]ocument
    (nnoremap-cb :gso vim.cmd.SymbolsOutline) ; [s]ymbol [o]utline
    (nnoremap-cb "]d" vim.diagnostic.goto_next)
    (nnoremap-cb "[d" vim.diagnostic.goto_prev)
    ;;
    ;; minimap
    ;;
    (nnoremap-cb "]m" vim.cmd.Minimap)
    (nnoremap-cb "[m" vim.cmd.MinimapClose)))

{}
