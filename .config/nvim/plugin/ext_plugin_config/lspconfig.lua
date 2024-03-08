local lsp_util = require'lspconfig'.util

require'lspconfig'.texlab.setup {}

-- language servers.
require'rust-tools'.setup {}
require'lspconfig'.nil_ls.setup {} -- nix language server.
require'lspconfig'.lua_ls.setup {
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
require'lspconfig'.tsserver.setup { cmd = { "typescript-language-server", "--stdio" } }
require'lspconfig'.pyright.setup { root_dir = lsp_util.find_git_ancestor }
require'lspconfig'.jsonls.setup { cmd = { "vscode-json-languageserver", "--stdio" } }
require'lspconfig'.terraformls.setup {}
-- require'lspconfig'.groovyls.setup { cmd = { "groovyls" } }

local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true
require'lspconfig'.html.setup { cmd = { "html-languageserver", "--stdio" }, capabilities = capabilities }
require'lspconfig'.cssls.setup { cmd = { "css-languageserver", "--stdio" }, capabilities = capabilities }

require'lspconfig'.sqlls.setup {}
require'lspconfig'.nickel_ls.setup{}

-- wip
-- require'lspconfig'.dockerls.setup{}
-- require'lspconfig'.tflint.setup{}

-- local null_ls = require'null-ls'
-- null_ls.setup({
--   sources = { null_ls.builtins.diagnostics.pylint }
-- })
-- require'lspconfig'.docker_compose_language_service.setup{}

-- completion.
require'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities())


-- vim.api.nvim_create_augroup("hover", {})
-- vim.api.nvim_create_autocmd({ "CursorHoldI" }, { group = "hover", callback = vim.lsp.buf.signature_help })
-- vim.api.nvim_create_autocmd({ "CursorHoldI" }, { group = "hover", callback = vim.lsp.buf.hover })

-- vim.api.nvim_create_augroup("doc_highlight", {})
-- vim.api.nvim_create_autocmd({ "CursorHold" }, { group = "doc_highlight", callback = vim.lsp.buf.document_highlight })
-- vim.api.nvim_create_autocmd({ "CursorHoldI" }, { group = "doc_highlight", callback = vim.lsp.buf.document_highlight })
-- vim.api.nvim_create_autocmd({ "CursorMoved" }, { group = "doc_highlight", callback = vim.lsp.buf.clear_references })
