--- note: this uses the component from the other pack!
--- todo: update this.
local cg = require 'pack.statusline.util.component'
local util = require 'pack.statusline.util.util'
local symbols = require'pack.statusline.util.symbols'

local tabline_std = cg:new{ hl_name = 'Tabline' }
local tabline_fill = cg:new{ hl_name = 'Statusline' }
local tabline_sel = tabline_std:reversed('TablineSel')

--- @return string tabline
vim.g.MakeTabline = function()
    local current_tab = vim.fn.tabpagenr()
    local num_tabs = vim.fn.tabpagenr('$')
    local transition_header_to_fill = tabline_std:get_transition_to(tabline_fill, 'background', symbols.left_tr)
        :get_value()
    local tabl = tabline_std:set ' ' .. util.get_branch() .. ' ' .. transition_header_to_fill
    tabl = tabl .. tabline_fill:set '' .. '%= ' -- right align tabs.

    local selection_state
    if current_tab == 1 then
        selection_state = tabline_sel
    else
        selection_state = tabline_std
    end
    tabl = tabl .. selection_state:get_transition_to(tabline_fill, 'background', symbols.right_tr):get_value()

    local win_nr, win_id, buf_handle, buf_name, buf_name_tail
    for tab_nr = 1, num_tabs do
        -- set the color group prefix for highlighting.
        if tab_nr == current_tab then
            selection_state = tabline_sel
        else
            selection_state = tabline_std
        end
        win_nr = vim.fn.tabpagewinnr(tab_nr)
        win_id = vim.fn.win_getid(win_nr, tab_nr)
        buf_handle = vim.api.nvim_win_get_buf(win_id)
        buf_name = vim.api.nvim_buf_get_name(buf_handle)
        buf_name_tail = vim.fn.fnamemodify(buf_name, ':t')

        tabl = tabl .. selection_state:set(' ' .. tab_nr .. ' ' .. buf_name_tail .. ' ')
    end

    if num_tabs == current_tab then
        selection_state = tabline_sel
    elseif num_tabs > 1 then
        selection_state = tabline_std
    end
    -- tabl = tabl .. selection_state:get_transition_to(tabline_fill, 'background', symbols.left_tr):get_value()
    -- tabl = tabl .. tabline_fill:set '   '
    return tabl
end

vim.cmd('set tabline=%!MakeTabline()')
