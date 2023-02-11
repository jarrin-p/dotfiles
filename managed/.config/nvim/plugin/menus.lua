--- @file `files.lua`
--- @author jarrin-p
-- start by cleaning the menus out.
vim.cmd('aunmenu *')

--- @class menu_opts
--- @field name string name of the menu item.
--- @field map string keymap to provide for the map.
--- @field noremap? boolean default `false`. whether or not to search for remaps.
--- @field mode? string what modes this menu will be valid for. see `:h map-modes`.

--- @param opts menu_opts settings to pass to mapping. hover `opts` for details.
function AddMenuItem(opts)
    if not opts.map or not opts.name then
        print('`opts.map` not provided. aborting function.')
        return
    end
    local mode = opts.mode or ''
    local noremap = (opts.noremap and 'nno') or ''

    local cmd = table.concat({ mode .. noremap .. 'menu', opts.name, opts.map }, ' ')
    vim.cmd(cmd)
end
