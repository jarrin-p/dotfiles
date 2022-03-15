vim.g.sil_is_toggled = 0
vim.api.nvim_exec([[
function ToggleSil()
    if g:sil_is_toggled == 0
        noremap : :silent 
        let g:sil_is_toggled = 1
    else
        noremap : :
        let g:sil_is_toggled = 0
    endif
endfunction
]], false)
