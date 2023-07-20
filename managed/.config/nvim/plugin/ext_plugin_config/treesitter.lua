require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        -- note: if there's an issue with treesitter parsing, try
        -- uninstalling via nix, collecting garbage, re-installing.
        -- disable = { 'vim' },
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
}
