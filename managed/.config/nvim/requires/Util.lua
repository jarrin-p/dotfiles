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

Set = vim.o
GSet = vim.g
SetWinLocal = vim.wo
-- end shorthands }}}

--- colors {{{
-- TODO look into `set termguicolors=...`
-- specifying colors manually. makes tweaking easier
-- these are basically manually defined to line up with current color scheme config
Colors = {
      cyan = 81,
      dark_blue = 8,
      red = 9,
      none = 'none',
      cursorline = '#f0aa8a', -- dark wood
      -- cursorline = '#a9dd9d', -- bright green
      -- cursorline = '#fd8489', -- red
      -- cursorline = '#ffebc3', -- foreground, light wood
      h_split_underline = '#7f8f9f',
}
-- end colors }}}

--- pretty print function {{{
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
-- vim: fdm=marker foldlevel=0
