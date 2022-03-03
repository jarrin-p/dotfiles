local vim = vim
local exec = function (str) vim.api.nvim_exec(str, false) end

exec 'hi clear FoldColumn'
exec 'hi FoldColumn ctermfg=8'

exec 'hi clear SignColumn'

exec 'hi clear StatusLine'
exec 'hi clear StatusLineNC'
exec 'hi StatusLine cterm=italic'

exec 'hi clear VertSplit'

exec 'hi clear Search'
exec 'hi Search cterm=bold,underline'

exec 'hi clear Folded'
exec 'hi Folded ctermfg=8 cterm=italic'

exec 'hi clear FgCocHintFloatBgCocFloating'
exec 'hi FgCocHintFloatBgCocFloating ctermbg=242'
exec 'hi clear Pmenu'
exec 'hi Pmenu ctermbg=242'

exec 'hi clear MatchParen'
exec 'hi MatchParen cterm=bold,italic'

exec 'hi javaLangObject ctermfg=8 cterm=bold'

exec 'hi clear CursorLine'
exec 'hi CursorLine ctermbg=0'

exec 'hi CursorLineNr cterm=none ctermbg=0'
