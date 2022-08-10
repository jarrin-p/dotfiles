-- lua format.
vim.bo.formatprg = table.concat({ 'lua-format', '-c', '$HOME/.luaformat' }, ' ')
