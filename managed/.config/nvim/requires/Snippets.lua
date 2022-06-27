--- @author jarrin-p
--- @file `Plugins.lua`

--- setup {{{
LS = require 'luasnip'
SelectChoice = require 'luasnip.extras.select_choice'
LS.cleanup() -- clears all snippets
-- end setup }}}

--- insert mode remaps {{{
--- for use with `luasnip`, when in a choice node this function will change,
-- otherwise it will use the fallback function.
-- @param direction (integer) 1 for changing choice forward, -1 for backward.
-- @param fallback (function) function to be used for fallback. defaults to doing nothing.
function ChooseSnipOrFallback(direction, fallback)
    fallback = fallback or function() end
    if LS.choice_active() then
        LS.change_choice(direction)
    else
        fallback()
    end
    vim.g.MakeStatusLine()
end

--- for use with `luasnip`, when in a choice node this function will change,
-- otherwise it will use the fallback function.
-- @param direction (integer) 1 for jumping forward, -1 for backward.
-- @param fallback (function) function to be used for fallback. defaults to doing nothing.
function JumpOrFallback(direction, fallback)
    fallback = fallback or function() end
    if LS.jumpable(direction) then
        LS.jump(direction)
    elseif LS.expandable() then
        LS.expand()
    else
        fallback()
    end
    vim.g.MakeStatusLine()
end

vim.api.nvim_set_keymap(
    'i',
    '<tab>',
    '<c-o>:lua JumpOrFallback(1)<enter>',
    {noremap = true, silent = true}
)
vim.api.nvim_set_keymap(
    'i',
    '<s-tab>',
    '<c-o>:lua JumpOrFallback(-1)<enter>',
    {noremap = true, silent = true}
)
vim.api.nvim_set_keymap(
    'i',
    '<c-j>',
    '<c-o>:lua ChooseSnipOrFallback(1)<enter>',
    {noremap = true, silent = true}
)
vim.api.nvim_set_keymap(
    'i',
    '<c-k>',
    '<c-o>:lua ChooseSnipOrFallback(-1)<enter>',
    {noremap = true, silent = true}
)
-- end insert mode remaps }}}

--- snippets {{{

--- postfix `function` snippet maker function. {{{
-- makes local have higher priority choice when local is the trigger.
-- @param trigger (string) the string for activating the snippet.
local function postfixFunctionSnipLua(trigger)

    --- hack to fix the spacing weirdness from multiline postfix.
    -- issue is more likely that postfix snippets shouldn't be multi-line.
    -- @param parent gets passed in by postfix node.
    local fixPostfixSpacingFn = function(_, parent)
        local p = parent.snippet.env.POSTFIX_MATCH
        p = p:sub(p:find('^%s*')) -- lua patterns to find the max spaces from beginning of statment
        return p
    end

    if not trigger then return end
    local postfix = require('luasnip.extras.postfix').postfix

    -- returns the snippet node with different config
    return postfix({trig = trigger, match_pattern = '.*$'}, {

        -- adds the description before the line that was 'matched'.
        LS.function_node(fixPostfixSpacingFn, {}),
        LS.text_node({'--- description', ''}),

        -- inserts what was matched from the line (everything up until this postfix trigger).
        LS.function_node(function(_, parent) return parent.snippet.env.POSTFIX_MATCH end, {}),

        -- creates the `function()` and places jump position inside parenthesis for defining variables.
        LS.text_node({'function('}),
        LS.insert_node(1),
        LS.text_node({')', ''}),

        -- final jump is to the body of the function.
        LS.function_node(fixPostfixSpacingFn, {}),
        LS.text_node({'\t'}),
        LS.insert_node(0, '-- body...'),

        LS.text_node({'', ''}),
        LS.function_node(fixPostfixSpacingFn, {}),
        LS.text_node({'end'}),
    })
end -- }}}

--- `function` snippet maker function. {{{
--- basically just a way to prevent redundantly defining the same snippet just
-- to have two nodes rearranged based on the context.
-- @param trigger (string) the string for activating the snippet.
local function functionSnipLua(trigger)
    if not trigger then return end

    -- start choice node on 'local' if that's the trigger used.
    local scope_choice_node
    if trigger == 'local' then
        scope_choice_node = function(position) -- passing the position makes it easier to define
            return LS.choice_node(position, { LS.text_node({'local '}), LS.text_node({''}), })
        end
    else
        scope_choice_node = function(position)
            return LS.choice_node(position, { LS.text_node({''}), LS.text_node({'local '}), })
        end
    end

    -- returns the snippet node with different config
    return LS.snippet(trigger, {
        LS.text_node({'--- description', ''}),
        scope_choice_node(1),
        LS.text_node({'function '}),
        LS.insert_node(2, 'functionName'),
        LS.text_node({'('}),
        LS.insert_node(3),
        LS.text_node({')', '\t'}),
        LS.insert_node(0, '-- body...'),
        LS.text_node({'', '\treturn', 'end'}),
    })
end -- }}}

--- makes the snippet for `if` statements. {{{
local function makeIfSnippetLua()
    local makeIfSnippetNode = function(position)
        return LS.snippet_node(position, {
            LS.text_node('if '),
            LS.insert_node(1, 'condition'),
            LS.text_node({" then", "\t"}),
        })
    end

    local makeElseIfSnippetNode = function(position) end

    return LS.snippet("if", {
        LS.text_node({"if "}),
        LS.insert_node(1, "condition"),
        LS.text_node({" then", "\t"}),
        LS.insert_node(2, "-- body..."),
        LS.choice_node(3, {
            LS.text_node({""}),
            LS.snippet_node(nil, {
                LS.text_node({"", "elseif "}),
                LS.insert_node(1, "condition"),
                LS.text_node({" then", "\t"}),
                LS.insert_node(2, "-- body..."),
                LS.snippet_node(nil, {
                    LS.text_node({"", "else"}),
                    LS.text_node({"", "\t"}),
                    LS.insert_node(1, "-- body..."),
                }),
            }),
            LS.snippet_node(nil, {
                LS.text_node({"", "else"}),
                LS.text_node({"", "\t"}),
                LS.insert_node(1, "-- body..."),
            })
        }),
        LS.text_node({"", "end"})
    })
end -- }}}
-- end lua snippets }}}

--- lua snippets {{{
LS.add_snippets('lua',
    {
        functionSnipLua('function'),
        functionSnipLua('local'),
        postfixFunctionSnipLua('function()'),

        -- `if` statement with `elseif` and `else` choices.
        makeIfSnippetLua(),
    }
)
--- end lua snippets }}}
--- java snippets {{{
LS.add_snippets("java", {
        LS.snippet("pr", -- System.out.println()
        {
            LS.text_node({'System.out.println("'}),
            LS.insert_node(0),
            LS.text_node({'");'}),
        }),
        --- TODO make logs choice nodes.
        LS.snippet("log.i", -- log.info
        {
            LS.text_node({'log.info("'}),
            LS.insert_node(0),
            LS.text_node({'");'}),
        }),
        LS.snippet('log.e', -- log.error
        {
            LS.text_node({'log.error("'}),
            LS.insert_node(0),
            LS.text_node({'");'}),
        }),
        LS.snippet('@Mapping', -- mapping
        {
            LS.text_node({'@Mapping(target = "'}),
            LS.insert_node(1, 'sourceName'),
            LS.text_node({'", source = "'}),
            LS.insert_node(2, 'targetName'),
            LS.text_node({'")'}),
        }),
        LS.snippet('class', -- class
        {
            LS.choice_node(1, {
                LS.text_node({"private "}),
                LS.text_node({"public "}),
                LS.text_node({""}),
            }),
            LS.text_node({"class "}), -- each entry starts on a newline.
            LS.insert_node(2, "className"),
            LS.text_node({" {", "\t" }),
            LS.insert_node(0),
            LS.text_node({"", "}"}),
        }),
        LS.snippet('function', -- function
        {
            LS.choice_node(1, {
                LS.text_node({"private "}),
                LS.text_node({"public "}),
                LS.text_node({""}),
            }),
            LS.choice_node(2, {
                LS.text_node({""}),
                LS.text_node({"static "}),
            }),
            LS.insert_node(3, "returnType"),
            LS.text_node({" {", "" }), -- linebreaks are ""
            LS.text_node({"\t"}),
            LS.insert_node(0),
            LS.text_node({"", "}"}),
        }),
})
--- end java snippets }}}

-- vim: fdm=marker foldlevel=0
