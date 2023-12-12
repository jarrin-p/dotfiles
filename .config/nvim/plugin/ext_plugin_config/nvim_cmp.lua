local cmp = require 'cmp'
local LS = require 'luasnip'
cmp.setup {
    snippet = {
        expand = function(args)
            LS.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert(
        {
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },
            ['<Tab>'] = cmp.mapping(function(fallback)
                if LS.expand_or_jumpable() then
                    LS.expand_or_jump()
                elseif cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if LS.jumpable(-1) then
                    LS.jump(-1)
                elseif cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }
    ),
    sources = { { name = 'luasnip' }, { name = 'nvim_lsp' }, { name = 'conjure' } },
}
