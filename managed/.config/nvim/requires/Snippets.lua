--- @author jarrin-p
--- @file `Plugins.lua`

--- setup {{{
-- uses the format for node naming defined in `:h luasnip assumptions`
local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local postfix = require("luasnip.extras.postfix").postfix
local select_choice = require 'luasnip.extras.select_choice'
ls.cleanup() -- clears all snippets

-- end setup }}}

-- insert mode remaps {{{

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
    if ls.choice_active() then
        ls.change_choice(direction)
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
    if ls.jumpable(direction) then
        ls.jump(direction)
    elseif ls.expandable() then
        ls.expand()
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

-- lua snippets {{{

--- postfix `function` snippet maker function. {{{
--- makes local have higher priority choice when local is the trigger.
--- @param trigger (string) the string for activating the snippet.
local function postfixFunctionSnipLua(trigger)

    --- hack to fix the spacing weirdness from multiline postfix. issue is more likely that postfix snippets shouldn't be multi-line.
    --- @param parent s gets passed in by postfix node.
    local fixPostfixSpacingFn = function(_, parent)
        local p = parent.snippet.env.POSTFIX_MATCH
        p = p:sub(p:find('^%s*')) -- lua patterns to find the max spaces from beginning of statment
        return p
    end

    if not trigger then return end

    -- returns the snippet node with different config
    return postfix({trig = trigger, match_pattern = '.*$'}, {

        -- adds the description before the line that was 'matched'.
        f(fixPostfixSpacingFn, {}),
        t({'--- description', ''}),

        -- inserts what was matched from the line (everything up until this postfix trigger).
        f(function(_, parent) return parent.snippet.env.POSTFIX_MATCH end, {}),

        -- creates the `function()` and places jump position inside parenthesis for defining variables.
        t({'function('}),
        i(1),
        t({')', ''}),

        -- final jump is to the body of the function.
        f(fixPostfixSpacingFn, {}),
        t({'\t'}),
        i(0, '-- body...'),

        t({'', ''}),
        f(fixPostfixSpacingFn, {}),
        t({'end'}),
    })
end -- }}}

--- `function` snippet maker function. {{{
--- basically just a way to prevent redundantly defining the same snippet just
--- to have two nodes rearranged based on the context.
--- @param trigger string the string for activating the snippet.
local function functionSnipLua(trigger)
    if not trigger then return end
    -- start choice node on 'local' if that's the trigger used. {{{
    local scope_choice_node
    if trigger == 'local' then
        scope_choice_node = function(position) -- passing the position makes it easier to define
            return c(position, { t({'local '}), t({''}), })
        end
    else
        scope_choice_node = function(position)
            return c(position, { t({''}), t({'local '}), })
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
    --- TODO: currently works by the assigned defaults. goal is to generalize further.
    --- @args table arguments to pass in.
    --- @args.fn function function used to generate the docstring.
    --- @args.argnodes table nodes that should have their text used.
    --- @args.opts table additional opts to be passed through to nodes.
    local fn_node_dosctring = function(args)
        args = args or {}
        args.fn = args.fn or default_docstring_fn
        args.argnodes = args.argnodes or {3}
        args.opts = args.opts or {}
        return f(args.fn, args.argnodes, args.opts)
    end
    -- returns the snippet based on the context of the `trigger`.
    return s(trigger, {
        t({'--- description', ''}),
        fn_node_dosctring(),
        scope_choice_node(1),
        t({'function '}),
        i(2, 'functionName'),
        t({'('}),
        i(3),
        t({')', '\t'}),
        i(0, '-- body...'),
        t({'', '\treturn', 'end'}),
    })
end -- }}}

--- makes the snippet for `if` statements. {{{
--- work in progress.
local function makeIfSnippetLua()
    local makeIfSnippetNode = function(position)
        return sn(position, {
            t('if '),
            i(1, 'condition'),
            t({" then", "\t"}),
        })
    end

    local makeElseIfSnippetNode = function(position) end

    return s("if", {
        t({"if "}), i(1, "condition"), t({" then", "\t"}),
        i(2, "-- body..."),
        c(3, {  -- choice
            t({""}),
            sn(nil, {
                t({"", "elseif "}), i(1, "condition"), t({" then", "\t"}),
                i(2, "-- body..."),
                sn(nil, {
                    t({"", "else"}),
                    t({"", "\t"}), i(1, "-- body..."),
                }),
            }),
            sn(nil, {
                t({"", "else"}),
                t({"", "\t"}), i(1, "-- body..."),
            })
        }),
        t({"", "end"})
    })
end -- }}}

--- lua add snippets {{{
ls.add_snippets('lua',
    {
        functionSnipLua('function'),
        functionSnipLua('local'),
        postfixFunctionSnipLua('function()'),

        -- `if` statement with `elseif` and `else` choices.
        makeIfSnippetLua(),
    }
)

-- end lua snippets }}} }}}

-- java snippets {{{
--- generic template for creating simple substitution snippets.
--- @param trigger string word to trigger the snippet
--- @param output_statement string the function to call without parenthesis. i.e. System.out.println would be passed in for output_statement, and the output would be `System.out.println();` when calling the trigger.
local function makeSimpleOutputSnippet(trigger, output_statement)
    return s(trigger, {
        t({output_statement .. '('}),
        i(0),
        t({');'}),
    })
end

ls.add_snippets("java", {
        s("print", -- System.out.println()
        {
            t({'System.out.println('}), i(0), t({');'}),
        }),
        --- TODO make logs choice nodes.
        s("log.i", -- log.info
        {
            t({'log.info("'}), i(0), t({'");'}),
        }),
        s('log.e', -- log.error
        {
            t({'log.error("'}), i(0), t({'");'}),
        }),
        s('@Mapping', -- mapstruct mapping
        {
            t({'@Mapping(target = "'}), i(1, 'targetName'), t({'", source = "'}), i(0, 'sourceName'), t({'")'}),
        }),
})
--- end java snippets }}}

-- vim: fdm=marker foldlevel=0
