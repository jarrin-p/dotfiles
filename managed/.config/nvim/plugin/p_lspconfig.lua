require('nvim-lsp-installer').setup {}
local servers = {
    'pyright', 'jdtls', 'sumneko_lua', 'terraformls', 'bashls', 'remark_ls',
    'rnix', 'vimls', 'tsserver', 'groovyls',
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

nnoremap('gD', ':lua vim.lsp.buf.declaration()<enter>')
nnoremap('gd', ':lua vim.lsp.buf.definition()<enter>')
nnoremap('<leader>d', ':lua vim.lsp.buf.hover()<enter>')
nnoremap('gi', ':lua vim.lsp.buf.implementation()<enter>')
nnoremap('<leader>rn', ':lua vim.lsp.buf.rename()<enter>')
nnoremap('gc', ':lua vim.lsp.buf.code_action()<enter>')
nnoremap('g=', ':lua vim.lsp.buf.formatting()<enter>')
nnoremap('gw', ':lua vim.lsp.buf.workspace_symbol()<enter>')
nnoremap('gs', ':lua vim.lsp.buf.signature_help()<enter>')
