-- lua format.
vim.bo.formatprg = table.concat({ 'lua-format', '-c', '$HOME/.luaformat' }, ' ')

local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local postfix = require('luasnip.extras.postfix').postfix
-- local isn = ls.indent_snippet_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require('luasnip.util.events')
-- local ai = require('luasnip.nodes.absolute_indexer')
-- local fmt = require('luasnip.extras.fmt').fmt
-- local m = require('luasnip.extras').m
-- local lambda = require('luasnip.extras').l
-- local select_choice = require 'luasnip.extras.select_choice'
ls.cleanup() -- clears all snippets

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

    if not trigger then
        return
    end

    -- returns the snippet node with different config
    return postfix(
        { trig = trigger, match_pattern = '.*$' }, {

            -- adds the description before the line that was 'matched'.
            f(fixPostfixSpacingFn, {}), t({ '--- description', '' }),

            -- inserts what was matched from the line (everything up until this postfix trigger).
            f(
                function(_, parent)
                    return parent.snippet.env.POSTFIX_MATCH
                end, {}
            ),

            -- creates the `function()` and places jump position inside parenthesis for defining variables.
            t({ 'function(' }), i(1), t({ ')', '' }), -- final jump is to the body of the function.
            f(fixPostfixSpacingFn, {}), t({ '\t' }), i(0, '-- body...'),
            t({ '', '' }), f(fixPostfixSpacingFn, {}), t({ 'end' }),
        }
    )
end

--- `function` snippet maker function. {{{
--- basically just a way to prevent redundantly defining the same snippet just
--- to have two nodes rearranged based on the context.
--- @param trigger string the string for activating the snippet.
local function functionSnipLua(trigger)
    if not trigger then
        return
    end
    -- start choice node on 'local' if that's the trigger used. {{{
    local scope_choice_node
    if trigger == 'local' then
        scope_choice_node =
            function(position) -- passing the position makes it easier to define
                return c(position, { t({ 'local ' }), t({ '' }) })
            end
    else
        scope_choice_node = function(position)
            return c(position, { t({ '' }), t({ 'local ' }) })
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
                table.insert(
                    return_args_table,
                        '-- @param ' .. arg .. ' TYPE description ...'
                )
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
        args.argnodes = args.argnodes or { 3 }
        args.opts = args.opts or {}
        return f(args.fn, args.argnodes, args.opts)
    end
    -- returns the snippet based on the context of the `trigger`.
    return s(
        trigger, {
            t({ '--- description', '' }), fn_node_dosctring(),
            scope_choice_node(1), t({ 'function ' }), i(2, 'functionName'),
            t({ '(' }), i(3), t({ ')', '\t' }), i(0, '-- body...'),
            t({ '', '\treturn', 'end' }),
        }
    )
end -- }}}

--- makes the snippet for `if` statements.
--- work in progress.
local function makeIfSnippetLua()
    local makeIfSnippetNode = function(position)
        return sn(
            position, { t('if '), i(1, 'condition'), t({ ' then', '\t' }) }
        )
    end

    local makeElseIfSnippetNode = function(position)
    end

    return s(
        'if', {
            t({ 'if ' }), i(1, 'condition'), t({ ' then', '\t' }),
            i(2, '-- body...'), c(
                3, { -- choice
                    t({ '' }), sn(
                        nil, {
                            t({ '', 'elseif ' }), i(1, 'condition'),
                            t({ ' then', '\t' }), i(2, '-- body...'),
                            sn(
                                nil, {
                                    t({ '', 'else' }), t({ '', '\t' }),
                                    i(1, '-- body...'),
                                }
                            ),
                        }
                    ),
                    sn(
                        nil, {
                            t({ '', 'else' }), t({ '', '\t' }),
                            i(1, '-- body...'),
                        }
                    ),
                }
            ), t({ '', 'end' }),
        }
    )
end

---
ls.add_snippets(
    'lua', {
        functionSnipLua('function'), functionSnipLua('local'),
        postfixFunctionSnipLua('function()'),

        -- `if` statement with `elseif` and `else` choices.
        makeIfSnippetLua(),
    }
)
