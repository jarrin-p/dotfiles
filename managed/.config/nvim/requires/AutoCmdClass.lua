require 'Global'

-- TODO switch to nvim api autocmd when available
AutoCmd = {
    args = {
        event = '',
        override = false,
        pattern = '*',
        once = '',
        nested = false,
        cmd = ''
    },

    -- creates a new autocmd object
    new = function(self, arg_table)
        -- arg_table: event (str), pattern (str), once (bool), nested (bool), cmd (str)
        if arg_table.once == true then arg_table.once = '++once' else arg_table.once = '' end
        if arg_table.override == true then arg_table.override = '!' else arg_table.override = '' end
        if arg_table.nested == true then arg_table.nested = '++nested' else arg_table.nested = '' end
        if not arg_table.pattern then arg_table.pattern = '*' end

        self.__index = self
        local obj = {}
        setmetatable(obj, self)

        for key, val in pairs(arg_table) do obj.args[key] = val end

        return obj
    end,

    -- adds autocmd
    add = function(self)
        -- prepping to make command: append a blank space to passed args, convert nil to '' so command doesn't break
        local args = {}
        for key, val in pairs(self.args) do args[key] = val .. ' ' end
        local command, count = 'autocmd' .. args.override .. ' ' .. args.event .. args.pattern .. args.once .. args.nested .. args.cmd, 0
        repeat command, count = string.gsub(command, '  ', ' ') until count == 0 -- trims extra whitespace
        Exec(command)
    end,
}
