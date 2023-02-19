local util = require 'util'
local lsp_util = require'lspconfig'.util
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
require'lspconfig'.pyright.setup { root_dir = lsp_util.find_git_ancestor }
require'lsp_signature'.setup()

-- completion.
require'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities())

util.nnoremap('gD', ':lua vim.lsp.buf.declaration()<enter>')
util.nnoremap('gd', ':lua vim.lsp.buf.definition()<enter>')
util.nnoremap('<leader>d', ':lua vim.lsp.buf.hover()<enter>')
util.nnoremap('gi', ':lua vim.lsp.buf.incoming_calls()<enter>')
util.nnoremap('<leader>rn', ':lua vim.lsp.buf.rename()<enter>')
util.nnoremap('gc', ':lua vim.lsp.buf.code_action()<enter>')
util.nnoremap('g=', ':lua vim.lsp.buf.format{async = false}<enter>')
util.nnoremap('gw', ':lua vim.lsp.buf.workspace_symbol()<enter>')
util.nnoremap('gs', ':SymbolsOutline<enter>')
util.nnoremap('gj', ':lua vim.diagnostic.goto_next()<enter>')
util.nnoremap('gk', ':lua vim.diagnostic.goto_prev()<enter>')

-- vim.api.nvim_create_augroup("hover", {})
-- vim.api.nvim_create_autocmd({ "CursorHoldI" }, { group = "hover", callback = vim.lsp.buf.signature_help })
-- vim.api.nvim_create_autocmd({ "CursorHoldI" }, { group = "hover", callback = vim.lsp.buf.hover })

-- vim.api.nvim_create_augroup("doc_highlight", {})
-- vim.api.nvim_create_autocmd({ "CursorHold" }, { group = "doc_highlight", callback = vim.lsp.buf.document_highlight })
-- vim.api.nvim_create_autocmd({ "CursorHoldI" }, { group = "doc_highlight", callback = vim.lsp.buf.document_highlight })
-- vim.api.nvim_create_autocmd({ "CursorMoved" }, { group = "doc_highlight", callback = vim.lsp.buf.clear_references })
