local os = require 'os'

--- set the env var `DOTFILES_LOG_LEVEL` to any of the keys here.
local level_map = {
    ERROR = 4,
    WARN = 3,
    INFO = 2,
    DEBUG = 1, -- debug appears to be a keyword.
}
M = {
    level_map = level_map,
    level = (function()
        local level = os.getenv('DOTFILES_LOG_LEVEL')
        if level and level_map[level] then
            return level_map[level]
        else
            return level_map.INFO
        end
    end)(),

    info = function(self, text)
        if (self.level <= self.level_map.INFO) then
            self.write(text, { 'INFO::' })
        end
    end,

    dbg = function(self, text)
        if (self.level <= self.level_map.DEBUG) then
            self.write(text, { 'DEBUG::' })
        end
    end,

    --- this should not be used externally.
    --- todo: create format settings for writing out with all log outputs.
    --- @param text string what to actually output.
    --- @param opts table options for output.
    write = function(text, opts)
        print(table.concat(opts, ' ') .. tostring(text))
    end,
}
return M
