(let [map #(vim.api.nvim_set_keymap "" $1 $2 {:noremap false :silent true})
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
    (nnoremap :gD ":lua vim.lsp.buf.declaration()<enter>")
    (nnoremap :gd ":lua vim.lsp.buf.definition()<enter>")
    (nnoremap :<leader>d ":lua vim.lsp.buf.hover()<enter>")
    (nnoremap :gi ":lua vim.lsp.buf.incoming_calls()<enter>")
    (nnoremap :<leader>rn ":lua vim.lsp.buf.rename()<enter>")
    (nnoremap :gc ":lua vim.lsp.buf.code_action()<enter>")
    (nnoremap :g= ":lua vim.lsp.buf.format{async = false}<enter>")
    (nnoremap :gsw ":lua vim.lsp.buf.workspace_symbol()<enter>") ; [s]ymbol [w]orkspace
    (nnoremap :gsd ":lua vim.lsp.buf.document_symbol()<enter>") ; [s]ymbol [d]ocument
    (nnoremap :gso ":SymbolsOutline<enter>") ; [s]ymbol [o]utline
    (nnoremap :<leader>j ":lua vim.diagnostic.goto_next()<enter>")
    (nnoremap :<leader>k ":lua vim.diagnostic.goto_prev()<enter>")
    ;;
    ;; minimap
    ;;
    (nnoremap :<leader>m ":MinimapToggle<enter>")))

{}
