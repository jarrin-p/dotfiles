require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        -- note: if there's an issue with treesitter parsing, try
        -- uninstalling via nix, collecting garbage, re-installing.
        -- disable = { 'vim' },
        additional_vim_regex_highlighting = false,
    },
}
