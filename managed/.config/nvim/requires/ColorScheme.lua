require 'Global'

--- alias for setting highlight
-- @see `:h nvim_set_hl`
local hl = vim.api.nvim_set_hl

-- color scheme
-- hl(0, 'CocInfoHighlight', { })
-- hl(0, 'CocUnusedHighlight', { ctermfg = 3 })
-- hl(0, 'CocWarningHighlight', { })
-- hl(0, 'FgCocHintFloatBgCocFloating', { ctermbg = 242 })
hl(0, 'CursorLine', { underline = 1, sp = Colors.h_split_underline, ctermbg = Colors.none })
hl(0, 'CursorLineNr', { ctermbg = Colors.none })
hl(0, 'DiffAdd', { ctermfg = 6, bold = 1 })
hl(0, 'DiffChange', { ctermfg = 12, italic = 1 })
hl(0, 'DiffDelete', { ctermfg = 1, bold = 1 })
hl(0, 'DiffText', { ctermfg = 11, bold = 1 })
hl(0, 'Error', { undercurl = 1, sp = 'red' })
hl(0, 'SpellBad', { undercurl = 1, sp = 'red' })
hl(0, 'FoldColumn', { ctermfg = Colors.dark_blue })
hl(0, 'Folded', { ctermfg = Colors.dark_blue, italic = 1 })
hl(0, 'MatchParen', { bold = 1, italic = 1 })
hl(0, 'Pmenu', { ctermbg = 242 })
hl(0, 'Search', { bold = 1, italic = 1, ctermfg = Colors.cyan })
hl(0, 'SpellCap', { ctermbg = Colors.darkblue, undercurl = 1, sp = 'gray' })
hl(0, 'SignColumn', { })
hl(0, 'StatusLine', { bold = 1, ctermfg = 0 })
hl(0, 'StatusLineNC', { italic = 1, ctermfg = 0 })
hl(0, 'TabLine', { ctermbg = 0 })
hl(0, 'TabLineFill', { ctermbg = 0 })
hl(0, 'Todo', { bold = 1 })
hl(0, 'Type', { italic = 1, ctermfg=121 })
hl(0, 'VertSplit', { ctermfg = 0 })
hl(0, 'javaLangObject', { ctermfg = Colors.dark_blue, bold = 1 })
