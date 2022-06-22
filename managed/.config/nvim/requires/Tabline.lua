--- @author jarrin-p
--- @file `Tabline.lua`

require 'Global'
require 'Snippets'
require 'Statusline'

function MakeTabLine()
    for i = 1, vim.fn.tabpagenr('$') do
        local selected = false
        if i == vim.fn.tabpagenr() then selected = true end
    end
end
