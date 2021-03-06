--- @author jarrin-p
--- @file `util.lua`
--- remap functions {{{
function map(lhs, rhs)
    vim.api.nvim_set_keymap('', lhs, rhs, { noremap = false, silent = true })
end

function nnoremap(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
end

--- assumes remap to normal mode.
function inoremap(lhs, rhs)
    vim.api.nvim_set_keymap(
        'i', lhs, '<c-o>' .. rhs, { noremap = true, silent = true }
    )
end

function tnoremap(lhs, rhs)
    vim.api.nvim_set_keymap('t', lhs, rhs, { noremap = true, silent = true })
end -- }}}

--- alias {{{
Exec = function(str, bool)
    bool = bool or false
    vim.api.nvim_exec(str, bool)
end -- }}}

--- RecurisvePrint(element, indent) {{{
--- recursively prints a table that has nested tables in a manner that isn't awful
--- @param element table the array or table to be printed
--- @param indent? string spaces that will be added in each level of recursion
function RecursivePrint(element, indent)
    indent = indent or ''
    if type(element) == 'table' then
        for key, val in pairs(element) do
            if type(val) == 'table' then
                print(indent .. key .. ':')
                RecursivePrint(val, indent .. '  ')
            else
                key = (type(key) == 'boolean' and (key and 'true' or 'false')
                          or key)
                val = (type(val) == 'boolean' and (val and 'true' or 'false')
                          or val)
                val = (type(val) == 'function' and 'function' or val)
                print(indent .. key .. ': ' .. val)
            end
        end
    end
end -- }}}

--- MakeGitSession(opts) {{{
--- @class make_git_session_opts
--- @field file_path? string
--- @field session_name? string

--- makes sessions in the git root directory if in one.
--- @param opts? make_git_session_opts
function MakeGitSession(opts)
    opts = opts or {}
    opts.session_name = opts.session_name or 'Session.vim'
    if vim.fn.FugitiveIsGitDir() == 1 then
        opts.file_path = opts.file_path or vim.fn.FugitiveWorkTree()
    end
    if not opts.file_path then
        return
    end -- don't litter sessions.
    vim.cmd(
        table.concat(
            { 'mksession!', opts.file_path .. '/' .. opts.session_name }, ' '
        )
    )
end -- }}}

--- LoadGitSession(opts) {{{
--- @class load_git_session_opts
--- @field file_path? string
--- @field session_name? string

--- makes sessions in the git root directory if in one.
--- @param opts? load_git_session_opts
function LoadGitSession(opts)
    opts = opts or {}
    opts.session_name = opts.session_name or 'Session.vim'
    if vim.fn.FugitiveIsGitDir() == 1 then
        opts.file_path = opts.file_path or vim.fn.FugitiveWorkTree()
    else
        opts.file_path = opts.file_path .. ' ' or ''
    end
    vim.cmd(
        table.concat(
            { 'source', opts.file_path .. '/' .. opts.session_name }, ' '
        )
    )
end -- }}}

--- CleanBufferPostSpace() {{{
--- cleans trailing whitespace in a file. win view is saved to keep cursor from jumping around from the substitute command.
function CleanBufferPostSpace()
    local view = vim.fn.winsaveview()
    vim.cmd('keepjumps silent %smagic/ *$//')
    vim.fn.winrestview(view)
end -- }}}

--- CurrentBufIsEmpty() {{{
--- check if buffer is empty
--- @return boolean
function CurrentBufIsEmpty()
    if vim.fn.line('$') == 1 and vim.fn.getline(1) == ''
        and vim.api.nvim_get_option_value('filetype', {}) == '' then
        return true
    end
    return false
end -- }}}

--- GetListedBufNames {{{
--- get list of buffers delimited using newlines by default.
--- @param delimiter? string (default '\\n') delimiter to use for returned table.
--- @return table bufnames the buffers as a table.
function GetListedBufNames(delimiter)
    delimiter = delimiter or '\n'

    local bufnames = {}
    for _, buffer in ipairs(vim.fn.getbufinfo()) do
        if buffer.listed == 1 then
            table.insert(bufnames, buffer.name)
        end
    end

    return bufnames
end -- }}}

--- BuildRipGrepCommand(opts) {{{
--- build rg command. anything that also accepts a function requires a return value of the expected type.
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
    if type(t) == 'function' then
        t = t()
    end -- apply the function if it is one.

    local t_delim = opts.t_delim or '\n'
    local pipe = opts.pipe or nil
    if pipe and t then
        print(
            'simultaneous use of tables and string piping is currently not supported'
        )
        return
    end

    local grep_cmd = opts.grep_cmd or 'rg'
    local grep_filter = opts.grep_filter or '""'

    -- set as table for future comparison or apply function if it is one.
    local grep_args = opts.grep_args or {}
    if type(grep_args) == 'function' then
        grep_args = grep_args()
    end

    local space_char = ' '
    local cmd = {}

    -- check if anything is going to be piped in.
    -- if it is then we want to prepend it to the full command using the delimiter.
    if t then
        pipe = table.concat(t, t_delim)
    end
    if pipe then
        table.insert(cmd, 'echo')
        table.insert(cmd, '"' .. pipe .. '"')
        table.insert(cmd, '|')
    end

    -- add the grep command.
    table.insert(cmd, grep_cmd)

    -- pass the additional args to the grep command if there are any.
    if #grep_args > 0 then
        for _, arg in ipairs(grep_args) do
            table.insert(cmd, arg)
        end
    end

    -- add the filter string. leaving as "" will allow full searching of the input.
    table.insert(cmd, grep_filter)

    -- returns the full command.
    return table.concat(cmd, space_char)
end -- }}}

--- PrepentToEachTableEntry(t, text_to_prepend) {{{
--- prepends to the front of each string in a table. does not update in place.
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
end -- }}}

--- SplitStringToTable(str, delim) {{{
--- split string into table. a quick implementation of the inverse of `table.concat`.
--- @param str string string to be broken apart.
--- @param delim string delimiter that determines where to break apart string.
--- @return table result_as_table the table of strings that were split.
function SplitStringToTable(str, delim)
    str = str .. delim -- append to make splitting easier.
    local result_as_table = {}
    for match in string.gmatch(str, '([^' .. delim .. ']+)' .. delim) do
        table.insert(result_as_table, match)
    end

    return result_as_table
end -- }}}

--- GetLSPKind(kind) {{{
--- kind of like an enum for converting the kind response from the LSP
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
end -- }}}

--- MakeFormatPrg() {{{
--- creates the string for a `formatprg` expression with escaped backslack `\` characters.
--- @param ext_command table
--- @return string|nil command the exact command string that should be evaluated, or nil if a table was not passed.
function MakeFormatPrgText(ext_command)
    if type(ext_command) ~= 'table' then
        return nil
    end
    local prefix = 'silent set formatprg='
    local command = prefix .. table.concat(ext_command, '\\ ')
    return command
end -- }}}

--- FF() (format file using formatprg) {{{
function FF()
    if vim.api.nvim_get_option_value('formatprg', {}) ~= '' then
        local view = vim.fn.winsaveview()
        vim.cmd('keepjumps silent norm gggqG')
        vim.fn.winrestview(view)
    end
end -- }}}

-- vim: fdm=marker foldlevel=0
