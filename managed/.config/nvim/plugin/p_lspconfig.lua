local rt = require("rust-tools")

rt.setup({
    -- server = {
    --     on_attach = function(_, bufnr)
    --         -- Hover actions
    --         vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
    --         -- Code action groups
    --         vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    --     end,
    -- },
})

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local r = require('lspconfig')

nnoremap('gD', ':lua vim.lsp.buf.declaration()<enter>')
nnoremap('gd', ':lua vim.lsp.buf.definition()<enter>')
nnoremap('<leader>d', ':lua vim.lsp.buf.hover()<enter>')
nnoremap('gi', ':lua vim.lsp.buf.implementation()<enter>')
nnoremap('<leader>rn', ':lua vim.lsp.buf.rename()<enter>')
nnoremap('gc', ':lua vim.lsp.buf.code_action()<enter>')
nnoremap('g=', ':lua vim.lsp.buf.formatting()<enter>')
nnoremap('gw', ':lua vim.lsp.buf.workspace_symbol()<enter>')
nnoremap('gs', ':lua vim.lsp.buf.signature_help()<enter>')
nnoremap('gj', ':lua vim.diagnostic.goto_next()<enter>')
nnoremap('gk', ':lua vim.diagnostic.goto_prev()<enter>')

-- vim.api.nvim_create_augroup("hover", {})
-- vim.api.nvim_create_autocmd({ "CursorHoldI" }, { group = "hover", callback = vim.lsp.buf.signature_help })
-- vim.api.nvim_create_autocmd({ "CursorHoldI" }, { group = "hover", callback = vim.lsp.buf.hover })

-- vim.api.nvim_create_augroup("doc_highlight", {})
-- vim.api.nvim_create_autocmd({ "CursorHold" }, { group = "doc_highlight", callback = vim.lsp.buf.document_highlight })
-- vim.api.nvim_create_autocmd({ "CursorHoldI" }, { group = "doc_highlight", callback = vim.lsp.buf.document_highlight })
-- vim.api.nvim_create_autocmd({ "CursorMoved" }, { group = "doc_highlight", callback = vim.lsp.buf.clear_references })
