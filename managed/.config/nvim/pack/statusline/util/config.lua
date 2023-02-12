local cg = require 'pack.statusline.util.component'
local util = require 'pack.statusline.util.util'

M = {}

M.fg = util.get_colorscheme_as_hex('Fg', 'foreground')
M.darker = util.get_colorscheme_as_hex('FloatBorder', 'background')
M.setup = function()
    local set_hl = vim.api.nvim_set_hl
    set_hl(0, 'StatuslineHeader', { fg = 'Black', bg = M.fg })
    set_hl(0, 'StatuslineFill', { fg = 'Black', bg = M.darker })
    set_hl(0, 'StatuslineDirectory',
        { italic = 1, fg = util.get_colorscheme_as_hex('Comment', 'foreground'), bg = M.darker })
end
M.setup()

-- define easier way to specify what values to set color groups in the status line.
M.directory = cg:new{ name = 'StatuslineDirectory' }
M.header = cg:new{ name = 'StatuslineHeader' }

-- define a few things that get reused.
M.dir_git = M.directory:set ' Git'
M.dir_fug = M.directory:set ' Fugitive'

-- generated values from transitions. 
M.transitions = { header_to_dir = M.header:get_transition_to(M.directory, 'background', Symbols.left_tr):get_value() }

M.buffer_types = { terminal = M.header:set 'Terminal  ' .. M.transitions.header_to_dir }
M.file_types = {
    minimap = M.header:set 'Minimap  ' .. M.transitions.header_to_dir,
    help = M.header:set 'Help  ' .. M.transitions.header_to_dir,
    qf = M.header:set 'Quick Fix || Location List  ' .. M.transitions.header_to_dir,
    fugitive = M.header:set 'Fugitive  ' .. M.transitions.header_to_dir .. M.dir_git,
    gitcommit = M.header:set 'Commit  ' .. M.transitions.header_to_dir .. M.dir_fug .. M.dir_git,
    git = M.header:set 'Branch  ' .. M.transitions.header_to_dir .. M.dir_fug .. M.dir_git,
}

return M
