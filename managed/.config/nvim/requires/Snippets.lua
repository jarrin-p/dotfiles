--- @author jarrin-p
--- @file `Plugins.lua`

--- setup {{{
LS = require 'luasnip'
SelectChoice = require 'luasnip.extras.select_choice'
LS.cleanup() -- clears all snippets
-- end setup }}}

--- insert mode remaps {{{

--- changes tab to be more shiftwidth-y.
--- we'll see if i like this. will probably continue to enhance.
function Tabbb(direction)
    direction = direction or -1
    local shift_direction = {[-1] = '<<', [1] = '>>'}

    -- mirror behavior of shiftwidth where tabstop is used when it equals zero.
    local shift_width = vim.api.nvim_get_option_value('shiftwidth', {})
    if shift_width == 0 then shift_width = vim.api.nvim_get_option_value('tabstop', {}) end

    -- handle forwards and backwards.
    if direction == -1 then
        shift_width = shift_width * (-1)
    end

    -- index is 3 for character position. @see `:h getcursorcharpos()`
    -- TODO look into neovim lua version updates, table.unpack doesn't exist.
    local _, row, col, _, _ = unpack(vim.fn.getcursorcharpos())
    local new_pos = col + shift_width

    -- local tab_stop = vim.api.nvim_get_option_value('tabstop', {})
    -- local spaces = ''
    -- for _ = 1, tab_stop do spaces = spaces .. ' ' end

    vim.cmd("normal!" .. shift_direction[direction])
    vim.fn.cursor(row, new_pos)
end

--- for use with `luasnip`, when in a choice node this function will change,
--- otherwise it will use the fallback function.
--- @param direction (integer) 1 for changing choice forward, -1 for backward.
--- @param fallback (function) function to be used for fallback. defaults to doing nothing.
function ChooseSnipOrFallback(direction, fallback)
    fallback = fallback or function() Tabbb(direction) end
    if LS.choice_active() then
        LS.change_choice(direction)
    else
        fallback()
    end
    vim.g.MakeStatusLine()
end

--- for use with `luasnip`, when in a choice node this function will change,
--- otherwise it will use the fallback function.
--- @param direction (integer) 1 for jumping forward, -1 for backward.
--- @param fallback (function) function to be used for fallback. defaults to doing nothing.
function JumpOrFallback(direction, fallback)
    fallback = fallback or function() Tabbb(direction) end
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

--- lua snippets {{{

--- postfix `function` snippet maker function. {{{
-- makes local have higher priority choice when local is the trigger.
-- @param trigger (string) the string for activating the snippet.
local function postfixFunctionSnipLua(trigger)

    --- hack to fix the spacing weirdness from multiline postfix. issue is more likely that postfix snippets shouldn't be multi-line.
    --- @param parent LS.snippet gets passed in by postfix node.
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
    -- start choice node on 'local' if that's the trigger used. {{{
    local scope_choice_node
    if trigger == 'local' then
        scope_choice_node = function(position) -- passing the position makes it easier to define
            return LS.choice_node(position, { LS.text_node({'local '}), LS.text_node({''}), })
        end
    else
        scope_choice_node = function(position)
            return LS.choice_node(position, { LS.text_node({''}), LS.text_node({'local '}), })
        end
    end -- }}}

    --- the default function that will be passed to the dosctring function.
    --- @param args (table) a table corresponding to the lines passed in from the `argnodes` argument.
    --- @param parent (table) the parent of the function node, used for getting additional information.
    --- @param user_args1 (string) clarify further...
    local default_docstring_fn = function(args, parent, user_args1)

        -- TODO: fix not splitting properly on `_` names.
        -- check if any arguments were added.
        if args[1][1] ~= '' then
            local return_args_table = {}
            local arguments = args[1][1]:gsub('%s', '') -- strip whitespace.
            arguments = arguments .. ',' -- add comma for simpler splitting.

            -- split alpha-numeric characters based on commas (the most common method of argument passing).
            for arg in arguments:gmatch('([^,])+,') do
                table.insert(return_args_table, '-- @param ' .. arg .. ' TYPE description ...')
            end
            table.insert(return_args_table, '') -- append newline for better formatting.

            -- each entry of a table is for a line.
            return return_args_table
        end

        -- if no arguments were added then no docstring needs to be generated.
        return ''
    end

    --- generates the template for dosctrings when creating a function by using a snippet.
    -- TODO: currently works by the assigned defaults. goal is to generalize further.
    -- @args (table) arguments to pass in.
    -- @args.fn (function) function used to generate the docstring.
    -- @args.argnodes (table) nodes that should have their text used.
    -- @args.opts (table) additional opts to be passed through to nodes.
    local fn_node_dosctring = function(args)
        args = args or {}
        args.fn = args.fn or default_docstring_fn
        args.argnodes = args.argnodes or {3}
        args.opts = args.opts or {}
        return LS.function_node(args.fn, args.argnodes, args.opts)
    end
    -- returns the snippet based on the context of the `trigger`.
    return LS.snippet(trigger, {
        LS.text_node({'--- description', ''}),
        fn_node_dosctring(),
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
--- lua add snippets {{{
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

-- end lua snippets }}}

--- java snippets {{{
--- generic template for creating simple substitution snippets.
-- @param trigger, (string) word to trigger the snippet
-- @param output_statement, (string) the function to call without parenthesis. i.e. System.out.println would be passed in for output_statement, and the output would be `System.out.println();` when calling the trigger.
local function makeSimpleOutputSnippet(trigger, output_statement)
    return LS.snippet(trigger, {
        LS.text_node({output_statement .. '('}),
        LS.insert_node(0),
        LS.text_node({');'}),
    })
end

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
        LS.snippet('@Mapping', -- mapstruct mapping
        {
            LS.text_node({'@Mapping(target = "'}),
            LS.insert_node(1, 'sourceName'),
            LS.text_node({'", source = "'}),
            LS.insert_node(0, 'targetName'),
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
