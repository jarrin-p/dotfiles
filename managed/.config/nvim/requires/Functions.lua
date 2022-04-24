local function goRight ()
    local winnr = vim.fn.winnr
    if winnr() == winnr('$') then
        -- move to next window / display
        vim.cmd('echo "hey"')
    else
        -- move to next vim split
        vim.cmd.('wincmd w')
    end
end

-- exec([[
-- function! IsRightMostWindow()
--     if winnr() == winnr('$')
--         return 0
--     endif
--     return 1
-- endfunction

-- function! IsLeftMostWindow()
--     if winnr() == 1
--         return 0
--     endif
--     return 1
-- endfunction
-- ]], false)
