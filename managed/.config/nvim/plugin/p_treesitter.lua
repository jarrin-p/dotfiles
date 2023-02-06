require'nvim-treesitter.configs'.setup {
    -- ensure_installed = 'all', -- 'all', 'maintained', or a table of languages
    -- sync_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
        disable = { 'vim', 'help', 'bash', 'zsh', 'sh', 'nix' }, -- format for disabling languages.
    },
}
