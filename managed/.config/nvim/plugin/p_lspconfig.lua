local util = require'lspconfig'.util
-- language servers.
require'rust-tools'.setup {}
require'lspconfig'.nil_ls.setup {}
require'lspconfig'.sumneko_lua.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
                workspace = {
                    library = {
                        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                    },
                },
            },
        },
    },
}
require'lspconfig'.tsserver.setup { cmd = { "typescript-language-server", "--stdio", "--tsserver-path", "tsserver" } }
require'lspconfig'.terraformls.setup {}
require'lspconfig'.pyright.setup { root_dir = util.find_git_ancestor }
require'lsp_signature'.setup()

-- completion.
require'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities())

nnoremap('gD', ':lua vim.lsp.buf.declaration()<enter>')
nnoremap('gd', ':lua vim.lsp.buf.definition()<enter>')
nnoremap('<leader>d', ':lua vim.lsp.buf.hover()<enter>')
nnoremap('gi', ':lua vim.lsp.buf.incoming_calls()<enter>')
nnoremap('<leader>rn', ':lua vim.lsp.buf.rename()<enter>')
nnoremap('gc', ':lua vim.lsp.buf.code_action()<enter>')
nnoremap('g=', ':lua vim.lsp.buf.format{async = false}<enter>')
nnoremap('gw', ':lua vim.lsp.buf.workspace_symbol()<enter>')
nnoremap('gs', ':SymbolsOutline<enter>')
nnoremap('gj', ':lua vim.diagnostic.goto_next()<enter>')
nnoremap('gk', ':lua vim.diagnostic.goto_prev()<enter>')

-- vim.api.nvim_create_augroup("hover", {})
-- vim.api.nvim_create_autocmd({ "CursorHoldI" }, { group = "hover", callback = vim.lsp.buf.signature_help })
-- vim.api.nvim_create_autocmd({ "CursorHoldI" }, { group = "hover", callback = vim.lsp.buf.hover })

-- vim.api.nvim_create_augroup("doc_highlight", {})
-- vim.api.nvim_create_autocmd({ "CursorHold" }, { group = "doc_highlight", callback = vim.lsp.buf.document_highlight })
-- vim.api.nvim_create_autocmd({ "CursorHoldI" }, { group = "doc_highlight", callback = vim.lsp.buf.document_highlight })
-- vim.api.nvim_create_autocmd({ "CursorMoved" }, { group = "doc_highlight", callback = vim.lsp.buf.clear_references })
