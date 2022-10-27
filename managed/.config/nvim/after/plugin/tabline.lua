-- custom tabline implementation.
vim.g.MakeTabline = function()

    -- tabl will be returned
    local tabl = ''
    local current_tab = vim.fn.tabpagenr()
    local num_tabs = vim.fn.tabpagenr('$')

    tabl = tabl .. '%#TabLineFill#'
    tabl = tabl .. '%=' -- right align tabs.
    for i = 1, num_tabs do

        -- set the color group prefix for highlighting.
        if i == current_tab then
            tabl = tabl .. '%#TabLineSel#'
        else
            tabl = tabl .. '%#TabLine#'
        end

        tabl = tabl .. ' ' .. i .. ' '
    end

    -- makes sure the fill is also after the tabs block.
    tabl = tabl .. '%#TabLineFill#'
    tabl = tabl .. '    ' -- padding.
    return tabl
end

vim.cmd('set tabline=%!MakeTabline()')
