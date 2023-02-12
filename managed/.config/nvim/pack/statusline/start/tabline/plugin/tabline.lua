--- note: this uses the component from the other pack!
--- todo: update this.
local cg = require 'pack.statusline.util.component'

local tabline_std = cg:new{ name = 'TabLine' }
local tabline_fill = cg:new{ name = 'Statusline' }
local tabline_sel = tabline_std:reversed('TabLineSel')
-- local tabline_sel = cg:new{ name = 'TabLineSel' }

--- @return string tabline
vim.g.MakeTabline = function()
    local current_tab = vim.fn.tabpagenr()
    local num_tabs = vim.fn.tabpagenr('$')
    local transition_header_to_fill = tabline_std:get_transition_to(tabline_fill, 'background', Symbols.left_tr)
        :get_value()
    local tabl = tabline_std:set ' ' .. GetBranch() .. ' ' .. transition_header_to_fill
    tabl = tabl .. tabline_fill:set '' .. '%= ' -- right align tabs.

    local selection_state
    if current_tab == 1 then
        selection_state = tabline_sel
    else
        selection_state = tabline_std
    end
    tabl = tabl .. selection_state:get_transition_to(tabline_fill, 'background', Symbols.right_tr):get_value()

    for i = 1, num_tabs do
        -- set the color group prefix for highlighting.
        if i == current_tab then
            selection_state = tabline_sel
        else
            selection_state = tabline_std
        end
        tabl = tabl .. selection_state:set(' ' .. i .. ' ')
    end
    -- tabl = tabl .. ' %t%M'

    -- makes sure the fill is also after the tabs block.
    if num_tabs == current_tab then
        selection_state = tabline_sel
    elseif num_tabs > 1 then
        selection_state = tabline_std
    end
    tabl = tabl .. selection_state:get_transition_to(tabline_fill, 'background', Symbols.left_tr):get_value()
    tabl = tabl .. tabline_fill:set '   '
    return tabl
end

vim.cmd('set tabline=%!MakeTabline()')
