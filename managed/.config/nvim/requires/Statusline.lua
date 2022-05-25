require 'Global'
require 'AutoCmdClass'

-- status line modifications
local bl, br = '«', '»' -- so i don't need to remember shortcuts
local te = '->'
local enter_sym = '⏎'
-- local te = '⋯'

-- some custom color groups for the status line
local hl = Vim.api.nvim_set_hl
hl(0, 'SLBracket', { bold = 0, underline = 1, ctermfg = 8, sp = Colors.h_split_underline })
hl(0, 'SLItem', { underline = 1, ctermfg = 121, sp = Colors.h_split_underline })
hl(0, 'SLDir', { underline = 1, italic = 1, ctermfg = 3, sp = Colors.h_split_underline })
hl(0, 'SLFilePath', { italic = 1, underline = 1, ctermfg = 7, sp = Colors.h_split_underline })
hl(0, 'SLFileHeader', { italic = 0, underline = 1, ctermfg = 11, sp = Colors.h_split_underline })
hl(0, 'SLModified', { italic = 0, underline = 1, ctermfg = 9, sp = Colors.h_split_underline })
-- hl(0, 'SLMatchUL', { underline = 1, ctermfg = Colors.h_split_underline, sp = Colors.h_split_underline })

-- functions for easily changing colors in statusline
local function bracket(text_to_color) return ('%#SLBracket#' .. (text_to_color or '')) end
local function header(text_to_color) return ('%#SLFileHeader#' .. (text_to_color or '')) end
local function directory(text_to_color) return ('%#SLDir#' .. (text_to_color or '')) end
local function sl_item(text_to_color) return ('%#SLItem#' .. (text_to_color or '')) end
local function mod(text_to_color) return ('%#SLModified#' .. (text_to_color or '')) end

-- work in progress status line
function GetGitRelativeDir()
    if Vim.api.nvim_get_option_value('filetype', {}) == 'help' then
        return header'Help'

    elseif Vim.api.nvim_get_option_value('filetype', {}) == 'qf' then
        return header'Quick Fix || Location List'

    elseif Vim.api.nvim_get_option_value('filetype', {}) == 'fugitive' then
        return header'Git -> Fugitive'

    elseif Vim.fn.FugitiveIsGitDir() == 1 then
        -- use fugitive function FugitiveWorkTree() to get directory of git repo
        local abs_file_path = {}
        for match in Vim.fn.expand('%:p'):sub(1):gmatch('/[^/]*') do table.insert(abs_file_path, (match:gsub('/', ''))) end

        local working_tree = Vim.fn.FugitiveWorkTree()
        local _, last_index = Vim.fn.FugitiveWorkTree():find('.*/')
        working_tree = (Vim.fn.FugitiveWorkTree():sub(last_index):gsub('/', ''))

        local index_of_dir = 1
        for i, item in ipairs(abs_file_path) do if item == working_tree then index_of_dir = i end end

        local git_root_rel_path = {}
        for i = #abs_file_path, index_of_dir, -1 do
            table.insert(git_root_rel_path, abs_file_path[i])
        end

        local status = ''
        while (#git_root_rel_path > 1) do
            status = status .. directory(table.remove(git_root_rel_path))
            status = status .. ' ' .. bracket(br) .. ' '
        end
        status = status .. header(table.remove(git_root_rel_path))
        return status
    else
        return header(Vim.fn.expand("%:p"))
    end
end

function GetBranch()
    if Vim.fn.FugitiveIsGitDir() == 1 then
        return sl_item("⤤ " .. Vim.fn.FugitiveHead()) .. bracket(" " .. te) .. ' '
    else
        return ''
    end
end

function AddSymbolIfSet(option, symbol_to_use)
    if (Vim.api.nvim_get_option_value(option, {}) == true) then
        return symbol_to_use
    else
        return ''
    end
end

function MakeStatusLine()
    -- lhs padding, also declaration for easier adjusting
    local sl = header'  '

    -- lhs
    sl = sl .. GetBranch()
    sl = sl .. sl_item"buf %n" -- buffer id

    -- where to truncate and where the statusline splits
    sl = sl .. "%<%="

    -- rhs
    sl = sl .. GetGitRelativeDir()
    sl = sl .. mod(AddSymbolIfSet('modified', '+')) -- modified status
    sl = sl .. header'  ' -- rhs padding
    SetWinLocal.statusline = sl
end

AutoCmd:new{event = 'WinEnter', cmd = 'lua MakeStatusLine()'}:add()
AutoCmd:new{event = 'BufWinEnter', cmd = 'lua MakeStatusLine()'}:add()
AutoCmd:new{event = 'VimEnter', cmd = 'lua MakeStatusLine()'}:add()
AutoCmd:new{event = 'WinNew', cmd = 'lua MakeStatusLine()'}:add()
AutoCmd:new{event = 'BufModifiedSet', cmd = 'lua MakeStatusLine()'}:add()
