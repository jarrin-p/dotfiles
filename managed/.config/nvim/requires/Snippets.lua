LS = require 'luasnip'
SelectChoice = require 'luasnip.extras.select_choice'
LS.cleanup() -- clears all snippets

--- insert mode remaps {{{
vim.api.nvim_set_keymap(
    'i',
    '<tab>',
    '<c-o>:lua LS.expand_or_jump()<enter><c-o>:lua MakeStatusLine()<enter>',
    {noremap = true, silent = true}
)
vim.api.nvim_set_keymap(
    'i',
    '<c-j>',
    '<c-o>:lua LS.change_choice(1)<enter><c-o>:lua MakeStatusLine()<enter>',
    {noremap = true, silent = true}
)
vim.api.nvim_set_keymap(
    'i',
    '<c-k>',
    '<c-o>:lua LS.change_choice(-1)<enter><c-o>:lua MakeStatusLine()<enter>',
    {noremap = true, silent = true}
)
-- end insert mode remaps }}}

--- lua snippets {{{
LS.add_snippets("lua",
    {
        -- function snippet
        LS.snippet("fn",
        {
            LS.choice_node(1, {
                LS.text_node({""}),
                LS.text_node({"local "})
            }),
            LS.text_node("function "),
            LS.insert_node(2, "functionName"),
            LS.text_node({"()", "" }), -- linebreaks are ""
            LS.text_node({"\t"}),
            LS.insert_node(0),
            LS.text_node({"", "end"}),
        })
    }
)
--- end lua snippets }}}

--- java snippets {{{
LS.add_snippets("java",
    {
        LS.snippet("difftest",
        {
            LS.text_node({"new test"})
        })
    }
)
--- end lua snippets }}}

-- vim: fdm=marker foldlevel=0
