Command = {
    args = {
        name = '',
        num_args = '',
        cmd = ''
    },

    -- creates a new autocmd object
    new = function(self, arg_table)
        -- arg_table: name (str), num_args (str), cmd (str)
        if not arg_table.name then return end
        if not arg_table.cmd then return end

        --exec([[ command -nargs=1 NTI let NERDTreeIgnore=<args> ]], false) -- takes an array

        self.__index = self
        local obj = {}
        setmetatable(obj, self)

        for key, val in pairs(arg_table) do obj.args[key] = val end

        return obj
    end,

    -- adds command
    add = function(self)
        -- prepping to make command: append a blank space to passed args, convert nil to '' so command doesn't break
        local args = {}
        for key, val in pairs(self.args) do args[key] = val .. ' ' end
        local command, count = 'command ' .. args.event .. args.pattern .. args.once .. args.nested .. args.cmd, 0
        repeat command, count = string.gsub(command, '  ', ' ') until count == 0 -- trims extra whitespace
        vim.api.nvim_exec(command, false)
    end,
}


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
