--- @author jarrin-p {{{
--- @description colorschemes are set in here. }}}

--- colors {{{
-- TODO look into `set termguicolors=...`
-- specifying colors manually. makes tweaking easier
-- these are basically manually defined to line up with current color scheme config
Colors = {
    cursorline = '#f0aa8a', -- dark wood
    none = 'none',

    term = {
        cyan = 81,
        blue_dark = 8,
        red = 9,
    },

    gui = {
        gray = '#859289',
        green_bright = '#a9dd9d',
        red = '#fd8489',
        wood_dark = '#f0aa8a',
        wood_light = '#ffebc3',
    }
}
-- end colors }}}


-- color scheme
vim.api.nvim_set_hl(0, 'CursorLine', { underline = 1, sp = Colors.gui.gray })
vim.api.nvim_set_hl(0, 'CursorLineNr', { ctermbg = Colors.none })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = 1, sp = Colors.gui.red })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { undercurl = 1, sp = Colors.gui.gray })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = 1, sp = Colors.gui.wood_dark })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = 1, sp = Colors.gui.wood_light })
vim.api.nvim_set_hl(0, 'DiffAdd', { fg = Colors.gui.green_bright, ctermfg = 6, bold = 1 })
vim.api.nvim_set_hl(0, 'DiffChange', { fg = Colors.gui.wood_light, ctermfg = 12, italic = 1 })
vim.api.nvim_set_hl(0, 'DiffDelete', { fg = Colors.gui.red, ctermfg = 1, bold = 1 })
vim.api.nvim_set_hl(0, 'DiffText', { fg = Colors.gui.wood_dark, ctermfg = 11 })
vim.api.nvim_set_hl(0, 'Error', { undercurl = 1, sp = 'red' })
-- vim.api.nvim_set_hl(0, 'FoldColumn', { ctermfg = Colors.term.blue_dark })
vim.api.nvim_set_hl(0, 'Folded', { fg = Colors.gui.gray, ctermfg = Colors.term.blue_dark, italic = 1 })
vim.api.nvim_set_hl(0, 'MatchParen', { fg = Colors.gui.red, bold = 1, italic = 1 })
vim.api.nvim_set_hl(0, 'NonText', { fg = Colors.gui.gray, ctermfg = Colors.term.blue_dark })
-- vim.api.nvim_set_hl(0, 'Pmenu', { ctermbg = 242 })
vim.api.nvim_set_hl(0, 'Search', { bold = 1, italic = 1, ctermfg = Colors.cyan, fg = Colors.gui.wood_light })
vim.api.nvim_set_hl(0, 'SignColumn', { })
vim.api.nvim_set_hl(0, 'SpecialKey', { italic = 1, fg = Colors.gui.gray })
vim.api.nvim_set_hl(0, 'SpellBad', { undercurl = 1, sp = Colors.gui.red })
vim.api.nvim_set_hl(0, 'SpellCap', { ctermbg = Colors.term.blue_dark, undercurl = 1, sp = Colors.gui.gray })
-- vim.api.nvim_set_hl(0, 'StatusLine', { bold = 1, ctermfg = 0 })
-- vim.api.nvim_set_hl(0, 'StatusLineNC', { italic = 1, ctermfg = 0 })
vim.api.nvim_set_hl(0, 'Todo', { bold = 1, fg = Colors.gui.gray })
-- vim.api.nvim_set_hl(0, 'Type', { italic = 1, ctermfg=121 })
vim.api.nvim_set_hl(0, 'VertSplit', { ctermfg = 0, fg = Colors.gui.gray })
vim.api.nvim_set_hl(0, 'Whitespace', { fg = Colors.gui.gray, ctermfg = Colors.term.blue_dark })
-- vim.api.nvim_set_hl(0, 'javaLangObject', { ctermfg = Colors.term.blue_dark, bold = 1 })
