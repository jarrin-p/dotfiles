--- @author jarrin-p
--- @file `snippets.lua`
local ls = require 'luasnip'

function Tabbb(direction)
    direction = direction or -1
    local shift_direction = { [-1] = '<<', [1] = '>>' }

    -- mirror behavior of shiftwidth where tabstop is used when it equals zero.
    local shift_width = vim.api.nvim_get_option_value('shiftwidth', {})
    if shift_width == 0 then
        shift_width = vim.api.nvim_get_option_value('tabstop', {})
    end

    -- handle forwards and backwards.
    if direction == -1 then
        shift_width = shift_width * (-1)
    end

    -- index is 3 for character position. @see `:h getcursorcharpos()`
    -- TODO look into neovim lua version updates, table.unpack doesn't exist.
    local _, row, col, _, _ = unpack(vim.fn.getcursorcharpos())
    local new_pos = col + shift_width

    -- local tab_stop = vim.api.nvim_get_option_value('tabstop', {})
    -- local spaces = ''
    -- for _ = 1, tab_stop do spaces = spaces .. ' ' end

    vim.cmd('normal!' .. shift_direction[direction])
    vim.fn.cursor(row, new_pos)
end

--- for use with `luasnip`, when in a choice node this function will change,
--- otherwise it will use the fallback function.
--- @param direction (integer) 1 for changing choice forward, -1 for backward.
--- @param fallback (function) function to be used for fallback. defaults to doing nothing.
function ChooseSnipOrFallback(direction, fallback)
    fallback = fallback or function()
        Tabbb(direction)
    end
    if ls.choice_active() then
        ls.change_choice(direction)
    else
        fallback()
    end
    vim.g.MakeStatusLine()
end

--- for use with `luasnip`, when in a choice node this function will change,
--- otherwise it will use the fallback function.
--- @param direction (integer) 1 for jumping forward, -1 for backward.
--- @param fallback (function) function to be used for fallback. defaults to doing nothing.
function JumpOrFallback(direction, fallback)
    fallback = fallback or function()
        Tabbb(direction)
    end
    if ls.jumpable(direction) then
        ls.jump(direction)
    elseif ls.expandable() then
        ls.expand()
    else
        fallback()
    end
    vim.g.MakeStatusLine()
end

vim.api.nvim_set_keymap(
    'i', '<tab>', '<c-o>:lua JumpOrFallback(1)<enter>',
        { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
    'i', '<s-tab>', '<c-o>:lua JumpOrFallback(-1)<enter>',
        { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'i', '<c-j>', '<c-o>:lua ChooseSnipOrFallback(1)<enter>',
        { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'i', '<c-k>', '<c-o>:lua ChooseSnipOrFallback(-1)<enter>',
        { noremap = true, silent = true }
)
-- end insert mode remaps }}}

-- vim: fdm=marker foldlevel=0
