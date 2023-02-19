--- @author jarrin-p
--- @file `util.lua`
local M = {
    map = function(lhs, rhs)
        vim.api.nvim_set_keymap('', lhs, rhs, { noremap = false, silent = true })
    end,

    nnoremap = function(lhs, rhs)
        vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
    end,

    buf_nnoremap = function(lhs, rhs)
        vim.api.nvim_buf_set_keymap(0, 'n', lhs, rhs, { noremap = true, silent = true })
    end,

    --- assumes remap to normal mode.
    inoremap = function(lhs, rhs)
        vim.api.nvim_set_keymap('i', lhs, '<c-o>' .. rhs, { noremap = true, silent = true })
    end,

    tnoremap = function(lhs, rhs)
        vim.api.nvim_set_keymap('t', lhs, rhs, { noremap = true, silent = true })
    end,

    exec = function(str, bool)
        bool = bool or false
        vim.api.nvim_exec(str, bool)
    end,

    --- make_session_on_git_root(opts)
    --- @class make_git_session_opts
    --- @field file_path? string
    --- @field session_name? string

    --- makes sessions in the git root directory if in one.
    --- @param opts? make_git_session_opts
    make_session_on_git_root = function(opts)
        opts = opts or {}
        opts.session_name = opts.session_name or 'Session.vim'
        if vim.fn.FugitiveIsGitDir() == 1 then
            opts.file_path = opts.file_path or vim.fn.FugitiveWorkTree()
        end
        if not opts.file_path then
            return
        end -- don't litter sessions.
        vim.cmd(table.concat({ 'mksession!', opts.file_path .. '/' .. opts.session_name }, ' '))
    end,

    --- load_sessions_from_git_root(opts) 
    --- @class load_git_session_opts
    --- @field file_path? string
    --- @field session_name? string

    --- makes sessions in the git root directory if in one.
    --- @param opts? load_git_session_opts
    load_session_from_git_root = function(opts)
        opts = opts or {}
        opts.session_name = opts.session_name or 'Session.vim'
        if vim.fn.FugitiveIsGitDir() == 1 then
            opts.file_path = opts.file_path or vim.fn.FugitiveWorkTree()
        else
            opts.file_path = opts.file_path .. ' ' or ''
        end
        vim.cmd(table.concat({ 'source', opts.file_path .. '/' .. opts.session_name }, ' '))
    end,

    --- cleans trailing whitespace in a file. win view is saved to keep cursor from jumping around from the substitute command.
    clean_buffer_postspace = function()
        -- TODO make this not keep jumps for undo with subs.
        -- local view = vim.fn.winsaveview()
        -- vim.cmd('keepjumps silent %smagic/ *$//')
        -- vim.fn.winrestview(view)
    end,

    --- get_listed_bufnames 
    --- get list of buffers delimited using newlines by default.
    --- @param delimiter? string (default '\\n') delimiter to use for returned table.
    --- @return table bufnames the buffers as a table.
    get_listed_bufnames = function(delimiter)
        delimiter = delimiter or '\n'

        local bufnames = {}
        for _, buffer in ipairs(vim.fn.getbufinfo()) do
            if buffer.listed == 1 then
                table.insert(bufnames, buffer.name)
            end
        end

        return bufnames
    end,

    --- StringToTable(str, delim) 
    --- split string into table. a quick implementation of the inverse of `table.concat`.
    --- @param str string string to be broken apart.
    --- @param delim string delimiter that determines where to break apart string.
    --- @return table result_as_table the table of strings that were split.
    string_to_table = function(str, delim)
        str = str .. delim -- append to make splitting easier.
        local result_as_table = {}
        for match in string.gmatch(str, '([^' .. delim .. ']+)' .. delim) do
            table.insert(result_as_table, match)
        end

        return result_as_table
    end,

    file_format = function()
        if vim.api.nvim_get_option_value('formatprg', {}) ~= '' then
            local view = vim.fn.winsaveview()
            vim.cmd('keepjumps silent norm gggqG')
            vim.fn.winrestview(view)
        end
    end,

    --- exports the cwd to a temp file gotten from the env variable $VIM_CWD_PATH
    export_cwd = function()
        -- cd %:p:h<enter>
        local cwd = vim.fn.getcwd()
        os.execute('echo "' .. cwd .. '" > ' .. os.getenv('VIM_CWD_PATH'))
    end,
}

return M

-- vim: fdm=marker foldlevel=0
