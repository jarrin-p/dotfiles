--- @author jarrin-p
--- @file `plugins.lua`
vim.cmd('let g:gruvbox_material_enable_italic = 1')
vim.cmd('colorscheme gruvbox-material')
require"nvim-tree".setup({
    renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = false,
        full_name = false,
        highlight_opened_files = "none",
        highlight_modified = "none",
        root_folder_label = ":~:s?$?/..?",
        indent_width = 2,
        indent_markers = {
            enable = false,
            inline_arrows = true,
            icons = { corner = "└", edge = "│", item = "│", bottom = "─", none = " " },
        },
        icons = {
            webdev_colors = true,
            git_placement = "after",
            modified_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = { file = true, folder = true, folder_arrow = true, git = true, modified = true },
            glyphs = {
                default = "",
                symlink = "",
                bookmark = "",
                modified = "·",
                folder = {
                    arrow_closed = "▸",
                    arrow_open = "▾",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    unstaged = "u",
                    staged = "✓",
                    unmerged = "",
                    renamed = "r",
                    untracked = "",
                    deleted = "",
                    ignored = "",
                },
            },
        },
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
        symlink_destination = true,
    },
})
