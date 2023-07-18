(local utils (require :utils))
(local map utils.map)
(local nnoremap utils.nnoremap)
(local inoremap utils.inoremap)
(local tnoremap utils.tnoremap)

(map :<space> :<leader>)
(nnoremap :Y :y$) ; change back to vanilla default.
(nnoremap :U :<c-r>) ; change U to redo because I'm simple and U confuses me.
(nnoremap "`" "'") ; swap mapping of "jump to mark's col,line" with "jump to mark's line".
(nnoremap "'" "`") ; swap mapping of "jump to mark's line" with "jump to mark's col,line".

;; increase or decrease respectively the font size via mapping.
(nnoremap :<leader>+ ":lua SetFontSize(1)")
(nnoremap :<leader>- ":lua SetFontSize(-1)")

;; insert mode maps
;; note: this `inoremap` prepends `<c-o>` for a single action.
(inoremap :<c-h> :b)
(inoremap :<c-l> :E<c-o>l)

;; window management
;; these apply to vertical splits as well, mimics my skhd behavior instead using ctrl modifier
(nnoremap :<c-h> :<c-w>W) ; previous window (above, left)
(nnoremap :<c-l> :<c-w>w) ; next window (below, right)

;; buffer navigating
(nnoremap :<c-b> ::b#<enter>)
(nnoremap :<c-j> ::bprev<enter>)
(nnoremap :<c-k> ::bnext<enter>)
(nnoremap :<c-t> ":tabedit %<enter>")
(nnoremap :<c-f> ":lcd %:p:h<enter>:pwd<enter>")
(nnoremap :<c-g> ::GT<enter>:pwd<enter>)

;; fold method changing
(nnoremap :<leader>zfi ":set foldmethod=indent<enter>")
(nnoremap :<leader>zfm ":set foldmethod=manual<enter>")

;; finding navigation
(nnoremap :<leader>n ::cnext<enter>)
(nnoremap :<leader>p ::cprev<enter>)
(nnoremap :<leader>t ::NvimTreeToggle<enter>)
(nnoremap :<leader>T ::NvimTreeFindFile<enter>)

;; terminal remaps
(tnoremap "<C-[>" :<C-\><C-n>)
(tnoremap :<c-h> :<C-\><C-n><c-w>W)
(tnoremap :<c-l> :<C-\><C-n><c-w>w)
