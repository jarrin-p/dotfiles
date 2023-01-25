-- todo: links MUST come after normal assignments.
-- todo: links persist to following :new delcarations for some reason
--       when not overwritten.
local tabline_sel_rev = InlineColorGroup:new{
    name = 'TabLine_Rev_Link',
    options = { fg = Colors.gui.boolean_fg, bg = Colors.gui.normal_bg },
}
local tabline_std_rev = InlineColorGroup:new{
    name = 'somethingrandom',
    options = { fg = Colors.gui.statusline_background_default, bg = Colors.gui.normal_bg },
}
local tabline_fill = InlineColorGroup:new{ name = 'TabLineFill_Link', options = { link = 'TabLineFill' } }
local tabline_sel = InlineColorGroup:new{
    name = 'TabLineSel_Link',
    options = { link = 'TabLineSel' },
    pretext = ' ',
    posttext = ' ',
}
local tabline_std = InlineColorGroup:new{
    name = 'TabLine_Link',
    options = { link = 'TabLine' },
    pretext = ' ',
    posttext = ' ',
}

--- @return string tabline
vim.g.MakeTabline = function()
    local current_tab = vim.fn.tabpagenr()
    local num_tabs = vim.fn.tabpagenr('$')
    local tabl = tabline_std:set(GetBranch()) .. tabline_std_rev:set(Symbols.left_tr)
    tabl = tabl .. tabline_fill:set '' .. '%= ' -- right align tabs.

    local right_sym
    if current_tab == 1 then
        right_sym = tabline_sel_rev:set(Symbols.right_tr)
    else
        right_sym = tabline_std_rev:set(Symbols.right_tr)
    end
    tabl = tabl .. right_sym

    for i = 1, num_tabs do
        -- set the color group prefix for highlighting.
        if i == current_tab then
            tabl = tabl .. tabline_sel:set(i)
        else
            tabl = tabl .. tabline_std:set(i)
        end
    end
    -- tabl = tabl .. ' %t%M'

    -- makes sure the fill is also after the tabs block.
    if num_tabs == current_tab then
        tabl = tabl .. tabline_sel_rev:set ''
    elseif num_tabs > 1 then
        tabl = tabl .. tabline_std_rev:set ''
    end
    tabl = tabl .. Symbols.left_tr
    tabl = tabl .. tabline_std_rev:set '    ' -- padding.
    return tabl
end

vim.cmd('set tabline=%!MakeTabline()')
