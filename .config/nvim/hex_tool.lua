local ceil = require 'math'.ceil
local M = {}
M.hex_table = {
    ['0'] = 0,
    ['1'] = 1,
    ['2'] = 2,
    ['3'] = 3,
    ['4'] = 4,
    ['5'] = 5,
    ['6'] = 6,
    ['7'] = 7,
    ['8'] = 8,
    ['9'] = 9,
    A = 10,
    B = 11,
    C = 12,
    D = 13,
    E = 14,
    F = 15,
    a = 10,
    b = 11,
    c = 12,
    d = 13,
    e = 14,
    f = 15
}

M.to_hex_table = {
    [0] = '0',
    [1] = '1',
    [2] = '2',
    [3] = '3',
    [4] = '4',
    [5] = '5',
    [6] = '6',
    [7] = '7',
    [8] = '8',
    [9] = '9',
    [10] = 'A',
    [11] = 'B',
    [12] = 'C',
    [13] = 'D',
    [14] = 'E',
    [15] = 'F'
}

--- @param hex string r, g, or b piece of the hex code.
function M.hex_to_rgb(hex, index)
    return M.hex_table[hex:sub(index, index)]
end

--- @param hex string r, g, or b piece of the hex code.
--- @return integer #color code for individual.
function M.convert_to_rgb(hex, index)
    local tens = M.hex_to_rgb(hex, index)
    local ones = M.hex_to_rgb(hex, index + 1)

    -- as color code corresponding to rgb.
    return tens * 16 + ones
end

--- @param front string hex for single r, g, b piece.
--- @param behind string hex for single r, g, b color.
--- @return integer #hex color for single r, g, b, after opacity applied.
function M.apply_opacity(front, behind, opacity)
    return ceil(opacity * front + (1 - opacity) * behind)
end

--- @param hex string whole hex code for color.
--- @return table #for rgb colors.
function M.get_hex_as_rgb_table(hex)
    return {
        r = M.convert_to_rgb(hex, 2),
        g = M.convert_to_rgb(hex, 4),
        b = M.convert_to_rgb(hex, 6),
    }
end

function M.apply_opacity_to_tables(front, behind, opacity)
    local out = {}
    for k, _ in pairs(front) do
        out[k] = M.apply_opacity(front[k], behind[k], opacity)
    end
    return out
end

--- @param rgb number numerical value of r or g or b.
--- @return string corresponding hex value.
function M.rgb_to_hex(rgb)
    return M.to_hex_table[(rgb - (rgb % 16)) / 16] .. M.to_hex_table[rgb % 16]
end

function M.convert_rgb_table_to_hex(rgb_table)
    local out = '#'
    out = out .. M.rgb_to_hex(rgb_table.r)
    out = out .. M.rgb_to_hex(rgb_table.g)
    out = out .. M.rgb_to_hex(rgb_table.b)
    return out
end

function M.apply_opacity_transition(front, back, opacity)
    local front_ = M.get_hex_as_rgb_table(front)
    local back_ = M.get_hex_as_rgb_table(back)
    local applied = M.apply_opacity_to_tables(front_, back_, opacity)
    return M.convert_rgb_table_to_hex(applied)
end

return M
