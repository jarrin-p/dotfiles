--- @author jarrin-p {{{
--- @file `Util.lua` }}}

--- remap functions {{{
function map (lhs, rhs)
    vim.api.nvim_set_keymap('', lhs, rhs, {noremap = false, silent = true})
end

function nnoremap (lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, {noremap = true, silent = true})
end

--- assumes remap to normal mode.
function inoremap (lhs, rhs)
    vim.api.nvim_set_keymap('i', lhs, '<c-o>' .. rhs, {noremap = true, silent = true})
end

function tnoremap (lhs, rhs)
    vim.api.nvim_set_keymap('t', lhs, rhs, {noremap = true, silent = true})
end
-- end remap functions }}}

--- shorthands {{{
Exec = function (str, bool)
    bool = bool or false
    vim.api.nvim_exec(str, bool)
end
-- end shorthands }}}

--- lua table recursive print function {{{
--- recursively prints a table that has nested tables in a manner that isn't awful
-- @param element the array or table to be printed
-- @param indent (optional) spaces that will be added in each level of recursion
function RecursivePrint(element, indent)
    indent = indent or ''
    if type(element) == 'table' then
        for key, val in pairs(element) do
            if type(val) == 'table' then
                print(indent .. key .. ':')
                RecursivePrint(val, indent .. '  ')
            else
                key = (type(key) == 'boolean' and (key and 'true' or 'false') or key)
                val = (type(val) == 'boolean' and (val and 'true' or 'false') or val)
                val = (type(val) == 'function' and 'function' or val)
                print(indent .. key .. ': ' .. val)
            end
        end
    end
end
-- end pretty print function }}}

--- make session wrapper. {{{
--- makes sessions in the git root directory if in one.
-- @param args (table) argument table.
-- @param args.path (string) path to put the session_name.
-- @param args.session_name (string) name to store. automatically appends .vim.
function MakeGitSession(args)
    args = args or {}
    args.session_name = args.session_name or "Session.vim"
    if vim.fn.FugitiveIsGitDir() == 1 then
        args.path = args.path or vim.fn.FugitiveWorkTree()
    end
    if not args.path then return end -- don't litter sessions.
    vim.cmd(table.concat({"mksession!", args.path .. '/' .. args.session_name}, " "))
end
-- end make session wrapper }}}

--- load session wrapper. {{{
--- makes sessions in the git root directory if in one.
-- @param args.path (string) path to put the session_name.
-- @param args.session_name (string) name to store. automatically appends .vim.
function LoadGitSession(args)
    args = args or {}
    args.session_name = args.session_name or "Session.vim"
    if vim.fn.FugitiveIsGitDir() == 1 then
        args.path = args.path or vim.fn.FugitiveWorkTree()
    else
        args.path = args.path .. " " or ""
    end
    vim.cmd(table.concat({"source", args.path .. '/' .. args.session_name}, " "))
end
-- end make session wrapper }}}

--- clean postspace {{{
--- cleans trailing whitespace in a file. win view is saved to keep cursor from jumping around from the substitute command.
function CleanFileTrailingWhitespace()
    local view = vim.fn.winsaveview()
    vim.cmd('keepjumps silent %smagic/ *$//')
    vim.fn.winrestview(view)
end

-- }}} end clean postspace

--- check if buffer is empty {{{
function CurrentBufIsEmpty()
    if vim.fn.line('$') == 1
        and vim.fn.getline(1) == ''
        and vim.api.nvim_get_option_value('filetype', {}) == '' then
        return true
    end
    return false
end
-- end IsBufEmpty() }}}

-- vim: fdm=marker foldlevel=0
