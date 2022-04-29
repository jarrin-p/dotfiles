-- TODO consider how to incorporate buffers <-> kitty tabs <-> mac spaces ?
-- TODO consider switch mac settings such that displays use same spaces?

local winnr = vim.fn.winnr -- create alias for getting winnr() (window number)
local v_sys = vim.fn.system -- create alias for system eval (captures shell command)

--- wrapper for terminal json parser `jq`
-- @see https://stedolan.github.io/jq/
function JQ (json_string, filter)
    return v_sys("echo '" .. json_string .. "'" .. ' | jq "' .. filter .. '"')
end

--- json parse. converts character such that they will end up in a lua table structure
-- that can simply be loaded in with `load`
-- @param json string that will end up in a lua table
function JsonToTable(json)
    json = json:gsub('"([%w%p]-)":', '%1 =')
    json = json:gsub('-', '_')
    json = json:gsub('%[', '%{')
    json = json:gsub('%]', '%}')

    local result, err = load('return ' .. json)
    result = result()
    return result, err
end

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
                print(indent .. key .. ': ' .. (type(val) == 'boolean' and (val and 'true' or 'false') or val))
            end
        end
    end
end

Kitty = {
    ls = nil,
    tab_id = nil,
}

--- alias for running the `kitty @ ls` command, which shows current session info such as tabs, windows, pids, etc.
-- @returns lua table containing `kitty @ ls` results
function Kitty:LS()
    self.ls = self.ls or JsonToTable(JQ(v_sys('kitty @ ls'), "."))
    return self.ls
end

function Kitty:GetTabs()
    return self:LS()[1].tabs
end

--- gets the active tab kitty has open by looping through all active tabs
-- TODO check all tabs
function Kitty:GetFocusedTab()
    self.tab_id = 1
    return self.ls[1].tabs
end

--- gets all the windows from the active tab kitty has open
-- @param focused_tab_json_string (optional) json string filtered down to kitty information about the focused tab.
-- @returns json string with all window information for the focused tab. basically just applies a filter.
function GetTabWindows(focused_tab_json_string)
    return JQ(focused_tab_json_string or GetFocusedKittyTab(), '.[0].windows')
end

--- counts the number of windows from the active tab kitty has open
-- @param windows_json_string (optional) json string of the focused tab windows from kitty.
-- @returns number of windows found in the tab
function GetNumberOfWindows(windows_json_string)
    return tonumber(JQ(windows_json_string or GetTabWindows(), '. | length'))
end

--- gets the window that's focused
-- @param windows_json_string (optional) json string of the focused tab windows from kitty.
-- @returns id of focused window
function GetFocusedKittyWindowPosition(tab_windows_json_string, window_count)
    local windows = tab_windows_json_string or GetTabWindows()
    window_count = window_count or GetNumberOfWindows(windows)

    for i = 0, window_count-1 do
        -- trim out the newline attached to 'true', 'false' using gsub
        if JQ(windows, '.[' .. i .. '].is_focused'):gsub('%s+', '') == 'true' then
            return i + 1
        end
    end
end

--- goes to the next kitty window
-- @param focused_window_position integer, position of the next window from left to right
-- @see https://sw.kovidgoyal.net/kitty/remote-control/#kitty-focus-window
function GoToNextKittyWindow(focused_window_position)
    local window_id = focused_window_position or GetFocusedKittyWindowPosition()
    v_sys('kitty @ focus-window --match num:' .. window_id + 1)
end

--- runs a yabai query on the space
function YabaiGetQuery(type)
    local raw = v_sys('yabai -m query --' .. type)
    local as_json = JQ(raw, ".")
    return JsonToTable(as_json)
end

--- gets active yabai window id
-- @param json (optional) string of query

--- @see `man yabai` for more details about focus options
function YabaiFocusWindow(message) v_sys('yabai -m window --focus ' .. message) end

--- @see `man yabai` for more details about focus options
function YabaiFocusDisplay(message) v_sys('yabai -m display --focus ' .. message) end

--- finds the window id of the current focused window
-- @param windows table with all the window values
-- @see JsonToTable()
function YabaiGetFocusedWindow(windows)
    for _, window in pairs(windows) do
        if window.focused == 1 then return window end
    end
end

--- finds the focused space from a given index
function YabaiGetFocusedSpace(spaces)
    for _, space in pairs(spaces) do
        if space.focused == 1 then return space end
    end
end

function YabaiGetFocusedDisplay(displays, space_id_focused)
    for _, display in pairs(displays) do
        for _, space_index in ipairs(display.spaces) do
            if space_index == space_id_focused then return display end
        end
    end
end

--- handles where focus should go
-- TODO move left as well
function GoNext()

    -- if the current window number is equal to the last window number
    if winnr() == winnr('$') then
        local r = RecursivePrint
        r(Kitty:GetTabs())

        -- -- get the active window id to switch to if it exists
        --if GetFocusedKittyWindowPosition() < GetNumberOfWindows() then
        --    GoToNextKittyWindow()
        --    return
        --end

        -- -- if not last window get focused window id and its space
        -- local window = YabaiGetFocusedWindow(YabaiGetQuery("windows"))
        -- local space = YabaiGetFocusedSpace(YabaiGetQuery("spaces"))
        -- if window.id ~= space.last_window then
        --     YabaiFocusWindow('next')
        --     return
        -- end

        -- -- yabai will try to go to the next display. no harm done if none found,
        -- -- no additional logic necessary
        -- YabaiFocusDisplay("next")
    else
        -- move to next vim split
        vim.cmd('wincmd w')
    end
end

function GoPrev()
    if winnr() == winnr('$') then -- checks if last window
        -- move to next window / display
        vim.cmd('echo "hey"')
    else
        -- move to next vim split
        vim.cmd('wincmd w')
    end
end

GoNext()
