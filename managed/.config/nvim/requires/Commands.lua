exec = vim.api.nvim_exec
vim.g.sil_is_toggled = 0
exec([[
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

exec([[ command -nargs=1 NTI let NERDTreeIgnore=<args> ]], false) -- takes an array
exec([[ command SA !cd $(git rev-parse --show-toplevel); gradle spotlessApply ]], false)
