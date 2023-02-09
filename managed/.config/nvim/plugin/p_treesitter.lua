require'nvim-treesitter.configs'.setup {
    -- ensure_installed = 'all', -- 'all', 'maintained', or a table of languages
    -- sync_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,

        -- todo: look into why these languages are throwing errors.
        disable = { 'vim', 'help', 'bash', 'zsh', 'sh', 'nix', 'dockerfile', 'make' },
    },
}
