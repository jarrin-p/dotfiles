local cg = require 'pack.statusline.util.component'
local symbols = require 'pack.statusline.util.symbols'
local spec = require 'pack.statusline.util.color_specs'
local get_colorscheme_as_hex = require 'utils.color-tool'["get-colorscheme-as-hex"]

local M = {}

M.fg = get_colorscheme_as_hex(spec.fg.hl_name, spec.fg.color_type)
M.lighter = get_colorscheme_as_hex(spec.lighter.hl_name, spec.lighter.color_type)
M.darker = get_colorscheme_as_hex(spec.darker.hl_name, spec.darker.color_type)

-- make sure we create the color groups before we start using them for
-- transitions.
local set_hl = vim.api.nvim_set_hl
set_hl(0, 'Statusline', { fg = 'Black', bg = M.darker })
M.fill = cg:new{ hl_name = 'Statusline' }

set_hl(0, 'StatuslineHeader', { fg = 'Black', bg = M.fg })
M.header = cg:new{ hl_name = 'StatuslineHeader' }

set_hl(0, 'StatuslineDirectory',
    { italic = 1, fg = get_colorscheme_as_hex('Comment', 'foreground'), bg = M.darker })
M.directory = cg:new{ hl_name = 'StatuslineDirectory' }

set_hl(0, 'StatuslineFtInfo', { fg = M.fg, bg = M.lighter })
M.ft_info = cg:new{ hl_name = 'StatuslineFtInfo' }

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
