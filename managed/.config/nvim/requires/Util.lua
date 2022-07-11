--- @author jarrin-p
--- @file `Util.lua`

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

--- get list of buffers delimited using newlines by default. {{{
--- @param delimiter? string (default '\\n') delimiter to use for returned table.
--- @return table bufnames the buffers as a table.
function GetListedBufNames(delimiter)
    delimiter = delimiter or '\n'

    local bufnames = {}
    for _, buffer in ipairs(vim.fn.getbufinfo()) do
        if buffer.listed == 1 then table.insert(bufnames, buffer.name) end
    end

    return bufnames
end
-- end get list of buffers }}}

-- build rg command. anything that also accepts a function requires a return value of the expected type. {{{
--- @class rg_cmd_opts
--- @field t? string[]|function lua table to be piped into grep.
--- @field t_delim? string when `t` exists, the delimiter for concatenation.
--- @field pipe? string string to be piped into grep.
--- @field grep_cmd? string the rg command to run. currently it's just rg, but will generalized for other searchers.
--- @field grep_args? table|function table of arguments to pass to the grep command.
--- @field grep_filter? string default no filter (empty string). check your grep cmd docs for more info.

--- builds the command that will be used for running ripgrep. supports piped or external filters.
--- @param opts rg_cmd_opts
--- @return string #command that will be run to execute ripgrep.
function BuildRipGrepCommand(opts)
    local t = opts.t or nil
    if type(t) == 'function' then t = t() end -- apply the function if it is one.

    local t_delim = opts.t_delim or '\n'
    local pipe = opts.pipe or nil
    if pipe and t then
        print('simultaneous use of tables and string piping is currently not supported')
        return
    end

    local grep_cmd = opts.grep_cmd or 'rg'
    local grep_filter = opts.grep_filter or '""'

    -- set as table for future comparison or apply function if it is one.
    local grep_args = opts.grep_args or {}
    if type(grep_args) == 'function' then grep_args = grep_args() end

    local space_char = " "
    local cmd = {}

    -- check if anything is going to be piped in.
    -- if it is then we want to prepend it to the full command using the delimiter.
    if t then pipe = table.concat(t, t_delim) end
    if pipe then
        table.insert(cmd, 'echo')
        table.insert(cmd, '"' .. pipe .. '"')
        table.insert(cmd, '|')
    end

    -- add the grep command.
    table.insert(cmd, grep_cmd)

    -- pass the additional args to the grep command if there are any.
    if #grep_args > 0 then
        for _, arg in ipairs(grep_args) do table.insert(cmd, arg) end
    end

    -- add the filter string. leaving as "" will allow full searching of the input.
    table.insert(cmd, grep_filter)

    -- returns the full command.
    return table.concat(cmd, space_char)
end
-- end build rg command }}}

--- prepends to the front of each string in a table. does not update in place. {{{
--- @param t table table of strings that will have each text have prepended.
--- @param text_to_prepend string what will be prepended.
--- @return table new table with text prepended.
function PrependToEachTableEntry(t, text_to_prepend)
    local returned_table = {}
    for _, value in ipairs(t) do
        if type(value) ~= 'string' then
            print('table contains non-string value. returning from function')
            return
        end
        table.insert(returned_table, text_to_prepend .. value)
    end
    return returned_table
end
-- end prepend function. }}}

--- split string into table. {{{
--- @param str string string to be broken apart.
--- @param delim string delimiter that determines where to break apart string.
function SplitStringToTable(str, delim)
    str = str .. delim -- append to make splitting easier.
    local result_as_table = {}
    for match in string.gmatch(str, '([^'.. delim.. ']+)' .. delim) do
        table.insert(result_as_table, match)
    end

    return result_as_table
end
-- end split string }}}

--- 'enum' for converting the kind response from the LSP
--- into a physical name. sets it if it hasn't been made yet.
--- @param kind number kind to convert.
function GetLSPKind(kind)
    if not LSPKindEnum then
        LSPKindEnum = {
            [1] = 'File',
            [2] = 'Module',
            [3] = 'Namespace',
            [4] = 'Package',
            [5] = 'Class',
            [6] = 'Method',
            [7] = 'Property',
            [8] = 'Field',
            [9] = 'Constructor',
            [10] = 'Enum',
            [11] = 'Interface',
            [12] = 'Function',
            [13] = 'Variable',
            [14] = 'Constant',
            [15] = 'String',
            [16] = 'Number',
            [17] = 'Boolean',
            [18] = 'Array',
            [19] = 'Object',
            [20] = 'Key',
            [21] = 'Null',
            [22] = 'EnumMember',
            [23] = 'Struct',
            [24] = 'Event',
            [25] = 'Operator',
            [26] = 'TypeParameter',
        }
    end
    return LSPKindEnum[kind]
end

-- vim: fdm=marker foldlevel=0
