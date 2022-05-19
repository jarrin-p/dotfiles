require 'Global'

-- status line modifications
local bl, br = '«', '»' -- so i don't need to remember shortcuts

--- used for creating a "pseudo" split line
function Underline(color_group_to_underline)
    return color_group_to_underline .. " guisp=" .. Colors.h_split_underline
end

CTermSettings = {
    underline = 'underline',
    bold = 'bold',
    italic = 'italic',
    strikethrough = 'strikethrough',
}

ColorGroup = {
    group_name = '', -- color group name
    font_settings = '', -- cterm
    text_color = '', -- ctermfg
    background = '', -- ctermbg
    special = '', -- guisp

    new_group = function(self, name)
        self.__index = self
        local obj = {}
        setmetatable(obj, self)
    end,
}

ColorGroups = {
    SLBracket = 'cterm=bold'
}

-- some custom color groups for the status line
Exec(Underline 'hi SLBracket cterm=bold,underline')
Exec(Underline 'hi SLFileHeader cterm=underline ctermfg=7')
Exec(Underline 'hi SLSep cterm=underline ctermfg=8')
Exec(Underline 'hi SLFilePath cterm=italic,underline ctermfg=0')

-- functions for easily changing colors in statusline
local function bracket(text_to_color) return ('%#SLBracket#' .. text_to_color) end
local function header(text_to_color) return ('%#SLFileHeader#' .. text_to_color) end
local function separator(text_to_color) return ('%#SLSep#' .. text_to_color) end
local function p(text_to_color) return ('%#SLFilePath#' .. text_to_color) end

local sl = "%-(" -- left justified item group
sl = sl .. bracket"[ "
sl = sl .. header"%{expand('%:t:r')}"
sl = sl .. header".%{expand('%:t:e')}" -- file name, file extension
sl = sl .. "%M%R%H%W" -- modifiers and other info
sl = sl .. bracket" ]"
sl = sl .. bracket"[ " .. header"buf %n" .. bracket" ]" -- buffer id
sl = sl .. "%)"
sl = sl .. "%<"

-- work in progress status line
function BuildExpanded() return vim.fn.expand("%:p"):gsub("/", " > ") end
-- sl = sl .. header"" .. BuildExpanded()

sl = sl .. "%=" -- group separator
sl = sl .. p"%{expand('%:p:header')} "
Set.statusline = sl
