local cg = require 'pack.statusline.util.component'
local util = require 'pack.statusline.util.util'
local symbols = util.symbols

M = {}

M.fg = util.get_colorscheme_as_hex('Fg', 'foreground')
M.lighter = util.get_colorscheme_as_hex('Tabline', 'background')
M.darker = util.get_colorscheme_as_hex('FloatBorder', 'background')

-- make sure we create the color groups before we start using them for
-- transitions.
local set_hl = vim.api.nvim_set_hl
set_hl(0, 'Statusline', { fg = 'Black', bg = M.darker })
M.fill = cg:new{ name = 'Statusline' }

set_hl(0, 'StatuslineHeader', { fg = 'Black', bg = M.fg })
M.header = cg:new{ name = 'StatuslineHeader' }

set_hl(0, 'StatuslineDirectory',
    { italic = 1, fg = util.get_colorscheme_as_hex('Comment', 'foreground'), bg = M.darker })
M.directory = cg:new{ name = 'StatuslineDirectory' }

set_hl(0, 'StatuslineFtInfo', { fg = M.fg, bg = M.lighter })
M.ft_info = cg:new{ name = 'StatuslineFtInfo' }

-- define a few things that get reused.
M.dir_git = M.directory:set ' Git'
M.dir_fug = M.directory:set ' Fugitive'

-- generated values from transitions.
M.transitions = {
    header_to_dir = M.header:get_transition_to(M.directory, 'background', symbols.left_tr):get_value(),
    fill_to_ft_info = M.ft_info:get_transition_to(M.fill, 'background', symbols.right_tr):get_value(),
}

M.buffer_types = { terminal = M.header:set '  Terminal  ' .. M.transitions.header_to_dir }
M.file_types = {
    minimap = M.header:set '  Minimap  ' .. M.transitions.header_to_dir,
    help = M.header:set '  Help  ' .. M.transitions.header_to_dir,
    qf = M.header:set '  Quick Fix || Location List  ' .. M.transitions.header_to_dir,
    fugitive = M.header:set '  Fugitive  ' .. M.transitions.header_to_dir .. M.dir_git,
    gitcommit = M.header:set '  Commit  ' .. M.transitions.header_to_dir .. M.dir_fug .. M.dir_git,
    git = M.header:set '  Branch  ' .. M.transitions.header_to_dir .. M.dir_fug .. M.dir_git,
}

return M
