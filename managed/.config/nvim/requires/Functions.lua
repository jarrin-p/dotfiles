-- TODO consider how to incorporate buffers <-> kitty tabs <-> mac spaces ?
-- TODO consider switch mac settings such that displays use same spaces?


local winnr = vim.fn.winnr -- create alias for getting winnr() (window number)
local v_sys = vim.fn.system -- create alias for system eval (captures shell command)

--- wrapper for terminal json parser `jq`
-- @see https://stedolan.github.io/jq/
function JQ (json_string, filter)
    return v_sys("echo '" .. json_string .. "'" .. ' | jq "' .. filter .. '"')
end

--- alias for running the 'kitty @ ls' command, which shows current session info such as tabs, windows, pids, etc.
function KittyLS() return v_sys('kitty @ ls') end

--- gets the active tab kitty has open by looping through all active tabs
-- @param kitty_ls (optional) json string of the return value of `kitty @ ls`. will run `kitty @ ls` if not passed.
function GetFocusedKittyTab(kitty_ls)
    return JQ(kitty_ls or KittyLS(), '.[0].tabs')
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
function GoToNextKittyWindow(focused_window_position)
    local window_id = focused_window_position or GetFocusedKittyWindowPosition()
    v_sys('kitty @ focus-window --match num:' .. window_id + 1)
end

--- alias for query
function YabaiQuery(focus_type, filter)
    focus_type = focus_type or "windows"
    filter = filter or "."
    return JQ(v_sys('yabai -m query --' .. focus_type), filter)
end

--- gets a value from a field based on the equality of a different field compared to a specified value.
-- @table arg_table values that should be passed in as arguments
-- @param field_name the json query field to look at
-- @param field_truth_value the value that will trigger `true` in the if statement
-- @param return_identifier the field value that will be returned from the if statement when true
-- @param focus_type string that can be either `displays`, `spaces`, or `windows`. defaults `windows`
-- @returns requested value. default is the id of the focused window
function GetYabaiDetail(arg_table)
    local focus_type = arg_table.focus_type or 'windows'
    local field_name = arg_table.field_name or 'focused'
    local field_truth_value = arg_table.field_truth_value or '1'
    local return_identifier = arg_table.return_identifier or 'index'

    local list_of = arg_table.yabai_query or YabaiQuery(focus_type)
    local window_count = GetNumberOfWindows(list_of)

    for i = 0, window_count-1 do
        -- trim out the newline attached to 'true', 'false' using gsub
        if JQ(list_of, '.[' .. i .. '].' .. field_name):gsub('%s+', '') == field_truth_value then
            return (JQ(list_of, '.[' .. i .. '].' .. return_identifier))
        end
    end
end

function GetFocusedSpaceWindowList(space_index)
    return YabaiQuery('spaces', '.index' .. space_index)
end

function FocusYabaiWindow(message)
    v_sys('yabai -m window --focus ' .. message)
end

function YabaiFocusDisplay(message)
    v_sys('yabai -m display --focus ' .. message)
end
--- handles where focus should go (rename to GoNext())
-- TODO move left as well
function GoNext()

    -- if the current window number is equal to the last window number
    if winnr() == winnr('$') then

        -- get the active window id to switch to if it exists
        if GetFocusedKittyWindowPosition() < GetNumberOfWindows() then
            GoToNextKittyWindow()
            return
        end

        -- setup for yabai
        local window_query = YabaiQuery('windows')
        local args = {
            yabai_query = window_query,
            field_name = 'focused',
            field_truth_value = '1',
        }

        args.return_identifier = 'id'
        local focused_window_id = tonumber(GetYabaiDetail(args))

        args.return_identifier = 'space'
        local focused_window_space_index = tonumber(GetYabaiDetail(args))

        local windows_in_space = YabaiQuery(
            'spaces',
            '.[] | select( .index == ' .. focused_window_space_index .. ' )'
        )

        local windows = JQ(windows_in_space, '.windows')
        local windows_count = tonumber(JQ(windows, '. | length'))

        -- windows
        for i = 0, windows_count-1 do
            local win = tonumber(JQ(windows, '.[' .. i .. ']'))
            if win == focused_window_id and i < windows_count-1 then
                FocusYabaiWindow('next')
            end
        end

        -- displays
        args.return_identifier = 'display'
        local focused_window_display_index = tonumber(GetYabaiDetail(args))

        local displays_count = tonumber(YabaiQuery('displays', '. | length'))
        local displays = YabaiQuery('displays')
        for i = 0, displays_count-1 do
            local disp = tonumber(JQ(displays, '.[' .. i .. '].index'))
            if disp == focused_window_display_index and i < displays_count-1 then
                YabaiFocusDisplay('next')
            end
        end
    else
        -- move to next vim split
        vim.cmd('wincmd w')
    end
end

function GoLeft()
    if winnr() == winnr('$') then -- checks if last window
        -- move to next window / display
        vim.cmd('echo "hey"')
    else
        -- move to next vim split
        vim.cmd('wincmd w')
    end
end

-- exec([[
-- function! IsRightMostWindow()
--         return 0
--     endif
--     return 1
-- endfunction

-- function! IsLeftMostWindow()
--     if winnr() == 1
--         return 0
--     endif
--     return 1
-- endfunction
-- ]], false)
