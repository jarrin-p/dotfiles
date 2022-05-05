local vim = vim
local exec = function (str) vim.api.nvim_exec(str, false) end

-- specifying colors manually. makes tweaking easier
local cyan = '81'
local dark_blue = '8'

-- custom groupings, basically.
local cursor_line_settings = 'none'

-- For kitty apprentice theme
exec 'hi clear FoldColumn'
exec('hi FoldColumn ctermfg=' .. dark_blue)

exec 'hi clear SignColumn'

exec 'hi clear StatusLine'
exec 'hi clear StatusLineNC'

exec 'hi StatusLine cterm=bold,underline ctermfg=0'
exec 'hi StatusLineNC cterm=italic,underline ctermfg=0'

exec 'hi clear VertSplit'
exec 'hi VertSplit ctermfg=0'

exec 'hi clear Search'
exec('hi Search cterm=bold,italic ctermfg=' .. cyan)

exec 'hi clear Folded'
exec('hi Folded ctermfg=' .. dark_blue .. 'cterm=italic')

exec 'hi clear FgCocHintFloatBgCocFloating'
exec 'hi FgCocHintFloatBgCocFloating ctermbg=242'
exec 'hi clear Pmenu'
exec 'hi Pmenu ctermbg=242'

exec 'hi clear MatchParen'
exec 'hi MatchParen cterm=bold,italic'

exec 'hi Type cterm=italic'

exec('hi javaLangObject ctermfg=' .. dark_blue .. ' cterm=bold')

exec 'hi clear CursorLine'
exec('hi CursorLine ctermbg=' .. cursor_line_settings)

exec('hi clear CursorLineNr')
exec('hi CursorLineNr cterm=none ctermbg=' .. cursor_line_settings)

exec 'hi DiffText ctermfg=0'

exec 'hi clear TabLine'
exec 'hi TabLine ctermbg=0'

exec 'hi clear TabLineFill'
exec 'hi TabLineFill ctermbg=0'

exec 'hi clear CocUnusedHighlight'
exec 'hi CocUnusedHighlight ctermfg=3'

exec 'hi clear DiffAdd'
exec 'hi clear DiffChange'
exec 'hi clear DiffDelete'
exec 'hi clear DiffText'
exec 'hi DiffAdd ctermfg=6 cterm=bold'
exec 'hi DiffChange ctermfg=12 cterm=italic'
exec 'hi DiffDelete ctermfg=1 cterm=bold'
exec 'hi DiffText ctermfg=11 cterm=bold'
