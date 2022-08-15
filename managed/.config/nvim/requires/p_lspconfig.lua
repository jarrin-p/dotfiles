require('nvim-lsp-installer').setup {}
local servers = {
    'pyright', 'jdtls', 'sumneko_lua', 'terraformls', 'bashls', 'remark_ls',
    'rnix', 'vimls', 'tsserver',
}

local capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)

local r = require('lspconfig')
for _, s in pairs(servers) do
    if s == 'sumneko_lua' then
        r[s].setup {
            capabilities = capabilities,
            settings = {
                Lua = {
                    version = 'LuaJIT',
                    diagnostics = { globals = { 'vim' } },
                },
            },
        }
    elseif s == 'bashls' then
        r[s].setup {
            capabilities = capabilities,
            filetypes = { 'sh', 'bash', 'zsh' },
        }
    elseif s == 'jdtls' then
        r[s].setup { capabilities = capabilities, use_lombok_agent = true }
    else
        r[s].setup { capabilities = capabilities }
    end
end
