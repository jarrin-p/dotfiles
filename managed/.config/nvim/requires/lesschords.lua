--- @author jarrin-p
--- @file `lesschords.lua`
local winnr = vim.fn.winnr -- create alias for getting winnr() (window number)
local v_sys = vim.fn.system -- create alias for system eval (captures shell command)

--- `jq` wrapper for terminal json parser
--- @depends_on `jq`
--- @see https://stedolan.github.io/jq/
function JQ(json_string, filter)
    return v_sys('echo \'' .. json_string .. '\'' .. ' | jq "' .. filter .. '"')
end

--- json parse. converts characters such that they will end up in a lua table structure
--- that can simply be loaded in with `load`
--- @param json string that will end up in a lua table
function JsonToTable(json)
    json = json:gsub('\\', '')
    json = json:gsub('"([%w%p]-)":', '%1 =')
    json = json:gsub('-', '_')
    json = json:gsub('%[', '%{')
    json = json:gsub('%]', '%}')

    local result, err = load('return ' .. json)
    result = result()
    return result, err
end

--- table that holds initial query. additionally, functions are defined on this table that operate on the list.
Kitty = { ls = nil }

--- alias for running the `kitty @ ls` command, which shows current session info such as tabs, windows, pids, etc.
--- @return table lua table containing `kitty @ ls` results
function Kitty:LS()
    return (JsonToTable(JQ(v_sys('kitty @ ls'), '.')))
end

--- gets all the tabs, based on `kitty @ ls` formatting
--- @return table
function Kitty:GetTabs()
    return self:LS()[1].tabs
end

--- gets the windows in the focused tab kitty has open by looping through all tabs
--- @return table
function Kitty:GetFocusedTabWindows()
    for i, val in ipairs(self:GetTabs()) do
        if val.is_focused == true then
            self.windows = self:GetTabs()[i].windows
        end
    end

    return self.windows
end

--- counts the number of windows from the active tab kitty has open
--- @return number@ number of windows found in the tab
function Kitty:GetNumberOfWindows()
    return #Kitty:GetFocusedTabWindows()
end

--- gets the position index (ascending from 1) of the window that's focused
--- `--match num` uses a counted position (index) left to right, starting from 0
--- @see https://sw.kovidgoyal.net/kitty/remote-control/#kitty-focus-window
--- @return number|nil@ position index of focused window
function Kitty:GetFocusedWindowPosition()
    for i, window in ipairs(Kitty:GetFocusedTabWindows()) do
        if window.is_focused == true then
            return i - 1
        end
    end
    return nil
end

--- goes to the next kitty window
function Kitty:NextWindow()
    local window_id = Kitty:GetFocusedWindowPosition()
    v_sys('kitty @ focus-window --match num:' .. window_id + 1)
end

--- goes to the next kitty window
--- @see https://sw.kovidgoyal.net/kitty/remote-control/#kitty-focus-window
function Kitty:PreviousWindow()
    local window_id = Kitty:GetFocusedWindowPosition()
    v_sys('kitty @ focus-window --match num:' .. window_id - 1)
end

Yabai = { windows = nil, spaces = nil, displays = nil }

TYPES = { window = 'window', space = 'space', display = 'display' }

QUERIES = { windows = 'windows', spaces = 'spaces', displays = 'displays' }

FOCUS = { next = 'next', prev = 'prev' }

--- runs a yabai query
--- @param type string type of query to run. can be `windows`, `spaces`, or `displays`
--- @return table@ a table converted from the json message received from the query to yabai
function Yabai:Query(type)
    return (JsonToTable(JQ(v_sys('yabai -m query --' .. type), '.')))
end

--- finds the window id of the current focused window
function Yabai:GetFocusedWindow()

    -- query windows
    self.windows = self:Query(QUERIES.windows)

    -- loop through windows to find the focused one
    for _, window in pairs(self.windows) do
        if window.focused == 1 then
            self.focused_window = window
        end
    end

    return self.focused_window
end

--- finds the focused space from a given index
function Yabai:GetFocusedSpace()

    -- query spaces
    self.spaces = self:Query(QUERIES.spaces)

    -- loop through spaces to find the focused one
    for _, space in pairs(self.spaces) do
        if space.focused == 1 then
            self.focused_space = space
        end
    end

    return self.focused_space
end

--- finds the focused display using the focused space index
function Yabai:GetFocusedDisplay()

    -- make sure all details have been found
    self.displays = self:Query(QUERIES.displays)
    self.focused_space = self:GetFocusedSpace()

    -- loop through displays to find the focused one
    for _, display in pairs(self.displays) do
        for _, space_index in ipairs(display.spaces) do
            if space_index == self.focused_space then
                self.focused_display = display
            end
        end
    end

    return self.focused_display
end

--- @see `man yabai` for more details about focus options
function Yabai:FocusWindow(message)
    v_sys('yabai -m window --focus ' .. message)
end

--- @see `man yabai` for more details about focus options
function Yabai:FocusDisplay(message)
    v_sys('yabai -m display --focus ' .. message)
end

--- goes to the next (neo)vim split, kitty split, mac space window, or display
--- in that priority order. used for allowing a single mapped key to have more
--- versatile navigation.
function GoNext()

    -- if the current window number is equal to the last window number
    if winnr() == winnr('$') then

        -- get the active window id to switch to if it exists
        if Kitty:GetFocusedWindowPosition() < Kitty:GetNumberOfWindows() - 1 then
            Kitty:NextWindow()

            -- check if the current window is the last window. if it is, go to the next window
        elseif Yabai:GetFocusedWindow().id ~= Yabai:GetFocusedSpace().last_window then
            Yabai:FocusWindow(FOCUS.next)

            -- since displays are the last case, yabai will try to go to the next display.
        else
            Yabai:FocusDisplay(FOCUS.next)
        end
    else
        -- move to next vim split
        vim.cmd('wincmd w')
    end
end

--- goes to the previous (neo)vim split, kitty split, mac space window, or display
--- in that priority order. used for allowing a single mapped key to have more
--- versatile navigation.
function GoPrev()

    -- if the current window number is equal to the last window number
    if winnr() == 1 then

        -- get the active window id to switch to if it exists
        if Kitty:GetFocusedWindowPosition() > 0 then
            Kitty:PreviousWindow()

            -- check if the current window is the last window. if it is, go to the next window
        elseif Yabai:GetFocusedWindow().id
            ~= Yabai:GetFocusedSpace().first_window then
            Yabai:FocusWindow(FOCUS.prev)

            -- since displays are the last case, yabai will try to go to the next display.
        else
            Yabai:FocusDisplay(FOCUS.prev)
        end
    else
        -- move to next vim split
        vim.cmd('wincmd W')
    end
end
