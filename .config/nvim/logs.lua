local os = require("os")
local tableMerge
local function _1_(from, onto)
  for key, val in pairs(from) do
    onto[key] = val
  end
  return onto
end
tableMerge = _1_
local M
do
  local level_map = {ERROR = 4, WARN = 3, INFO = 2, DEBUG = 1}
  local env_level = (os.getenv("DOTFILES_LOG_LEVEL") or "WARN")
  local level = level_map[env_level]
  local write
  local function _2_(level_check, details, logger, to_out)
    if ((logger.level <= level_check) and (logger["allowed-loggers"])[logger.logger]) then
      local output = (logger.logger .. " " .. table.concat(details, " ") .. tostring(to_out))
      print(output)
      return output
    else
      return nil
    end
  end
  write = _2_
  local _6_
  do
    local _4_ = level_map.DEBUG
    local _5_ = {"DEBUG "}
    local function _7_(...)
      return write(_4_, _5_, ...)
    end
    _6_ = _7_
  end
  local _10_
  do
    local _8_ = level_map.INFO
    local _9_ = {"INFO "}
    local function _11_(...)
      return write(_8_, _9_, ...)
    end
    _10_ = _11_
  end
  local _14_
  do
    local _12_ = level_map.WARN
    local _13_ = {"WARN "}
    local function _15_(...)
      return write(_12_, _13_, ...)
    end
    _14_ = _15_
  end
  local _18_
  do
    local _16_ = level_map.ERROR
    local _17_ = {"ERROR "}
    local function _19_(...)
      return write(_16_, _17_, ...)
    end
    _18_ = _19_
  end
  M = {level = level, logger = "logger", ["allowed-loggers"] = {init = "true"}, dbg = _6_, info = _10_, warn = _14_, err = _18_}
end
return M
