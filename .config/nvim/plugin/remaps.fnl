(let [{:nvim_set_keymap set-keymap} vim.api
      map #(vim.api.nvim_set_keymap "" $1 $2 {:noremap false :silent true})
      nnoremap #(vim.api.nvim_set_keymap :n $1 $2 {:noremap true :silent true})
      inoremap #(vim.api.nvim_set_keymap :i $1 (.. :<c-o> $2)
                                         {:noremap true :silent true})
      tnoremap #(vim.api.nvim_set_keymap :t $1 $2 {:noremap true :silent true})]
  (do
    (map :<space> :<leader>)
    (nnoremap :Y :y$)
    (nnoremap :g? ":Maps<enter>") ; fzf search for maps.
    (nnoremap :U :<c-r>) ; change U to redo because I'm simple and U confuses me.
    (nnoremap "`" "'") ; swap mapping of "jump to mark's col,line" with "jump to mark's line".
    (nnoremap "'" "`") ; swap mapping of "jump to mark's line" with "jump to mark's col,line".
    ;;
    ;; gui maps
    ;;
    (nnoremap :<leader>+ ":SetFontSize(1)") ; increase or decrease respectively the font size via mapping.
    (nnoremap :<leader>- ":SetFontSize(-1)")
    (nnoremap :<leader>w ":sil make<enter>")
    ;;
    ;; insert mode maps
    ;;
    (inoremap :<c-h> :b) ; note: this `inoremap` prepends `<c-o>` for a single action.
    (inoremap :<c-l> :E<c-o>l)
    ;;
    ;; window management
    ;; these apply to vertical splits as well, mimics my skhd behavior instead using ctrl modifier
    ;;
    (nnoremap :<c-h> :<c-w>W) ; previous window (above, left)
    (nnoremap :<c-l> :<c-w>w)
    ;;
    ;; buffer navigating
    ;;
    (nnoremap :<c-b> ":b#<enter>")
    (nnoremap :<c-j> ":bprev<enter>")
    (nnoremap :<c-k> ":bnext<enter>")
    (nnoremap :<c-t> ":tabedit %<enter>")
    (nnoremap :<c-f> ":lcd %:p:h<enter>:pwd<enter>")
    (nnoremap :<c-g> ":GT<enter>:pwd<enter>")
    ;;
    ;; fold method changing
    ;;
    (nnoremap :<leader>zfi ":set foldmethod=indent<enter>")
    (nnoremap :<leader>zfm ":set foldmethod=manual<enter>")
    ;;
    ;; finding navigation
    ;;
    (nnoremap :<leader>n ":cnext<enter>")
    (nnoremap :<leader>p ":cprev<enter>")
    (nnoremap :<leader>t ":NvimTreeToggle<enter>")
    (nnoremap :<leader>T ":NvimTreeFindFile<enter>")
    ;;
    ;; git
    ;;
    (nnoremap :<leader>G ":tab G<enter>")
    (nnoremap :<leader>b ":G branch<enter>")
    ;;
    ;; terminal remaps
    ;;
    (tnoremap "<C-[>" "<C-\\><C-n>")
    (tnoremap :<c-h> "<C-\\><C-n><c-w>W")
    (tnoremap :<c-l> "<C-\\><C-n><c-w>w")
    ;;
    ;; fzf
    ;;
    (nnoremap :<leader>f ":FZF <enter>")
    (nnoremap :<leader>B ":FuzzyBranchSelect<enter>")
    (nnoremap :<leader>h ":FuzzyBranchChanges<enter>")
    (nnoremap :<leader>H ":FuzzyBranchChangesSetBranch<enter>")
    (nnoremap :<leader>b ":FuzzyBufferSelect<enter>")
    (nnoremap :<leader>F ":FuzzyFindNoIgnore<enter>")
    (nnoremap :<leader>g ":FuzzyGrep<enter>")
    ;;
    ;; lsp
    ;;
    (set-keymap :n :g= "" {:callback #(vim.lsp.buf.format {:async false})})
    (set-keymap :n :gD "" {:callback vim.lsp.buf.declaration})
    (set-keymap :n :gd "" {:callback vim.lsp.buf.definition})
    (set-keymap :n :gi "" {:callback vim.lsp.buf.incoming_calls})
    (set-keymap :n :<leader>d "" {:callback vim.lsp.buf.hover})
    (set-keymap :n :gi "" {:callback vim.lsp.buf.incoming_calls})
    (set-keymap :n :<leader>rn "" {:callback vim.lsp.buf.rename})
    (set-keymap :n :gc "" {:callback vim.lsp.buf.code_action})
    (set-keymap :n :gsw "" {:callback vim.lsp.buf.workspace_symbol}) ; [s]ymbol [w]orkspace
    (set-keymap :n :gsd "" {:callback vim.lsp.buf.document_symbol}) ; [s]ymbol [d]ocument
    (set-keymap :n :gso "" {:callback vim.cmd.SymbolsOutline}) ; [s]ymbol [o]utline
    (set-keymap :n "[d" "" {:callback vim.diagnostic.goto_next})
    (set-keymap :n "]d" "" {:callback vim.diagnostic.goto_prev})
    ;;
    ;; minimap
    ;;
    (nnoremap :<leader>m ":MinimapToggle<enter>")))

{}
