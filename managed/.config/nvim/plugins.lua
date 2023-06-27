--- @author jarrin-p
--- @file `plugins.lua`

-- setup must be called before loading the colorscheme
-- Default options:
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})
vim.cmd("colorscheme gruvbox")

require"nvim-tree".setup({
    sync_root_with_cwd = false,
    respect_buf_cwd = false,
    view = { relativenumber = true, width = 50 },
    update_focused_file = { enable = true, update_root = true, ignore_list = {} },
    -- diagnostics = {
    --     enable = true,
    --     show_on_dirs = true,
    --     show_on_open_dirs = true,
    --     debounce_delay = 50,
    --     severity = { min = vim.diagnostic.severity.HINT, max = vim.diagnostic.severity.ERROR },
    --     icons = { hint = "", info = "i", warning = "w", error = "x" },
    -- },
    renderer = {
        add_trailing = false,
        group_empty = true,
        highlight_git = true,
        full_name = false,
        highlight_opened_files = "name",
        -- highlight_modified = "name",
        -- root_folder_label = ":~:s?$?/..?",
        indent_width = 2,
        indent_markers = {
            enable = false,
            inline_arrows = true,
            icons = { corner = "└", edge = "│", item = "│", bottom = "─", none = " " },
        },
        icons = {
            webdev_colors = true,
            git_placement = "after",
            -- modified_placement = "before",
            padding = "",
            symlink_arrow = " ➛ ",
            show = { file = true, folder = true, folder_arrow = true, git = true, },
            -- show = { file = true, folder = true, folder_arrow = true, git = true, modified = true },
            glyphs = {
                default = "",
                symlink = "",
                bookmark = "",
                -- modified = "*",
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
                    staged = "s",
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
