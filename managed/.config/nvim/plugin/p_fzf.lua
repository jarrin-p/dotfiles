--- basically an alias. wraps the `fzf#wrap` function to be conveniently called from lua.
--- @param opts table lua table equivalent to the table accepted by `fzf#wrap`.
local function fzf_wrap(opts) vim.fn['fzf#run'](vim.fn['fzf#wrap'](opts)) end

--- wraps a given function into a global function for callbacks that are required by vim functions.
--- @param fn function function to be wrapped into a global.
--- @return function the handler for the vim global function.
local function as_global(fn)
    vim.g.as_global = fn
    return vim.g.as_global
end

--- function that operates more as a descriptor for readability (and consequently allows commenting).
--- this is specifically for applying the generic `table.concat(t, sep = ' ')` that's used for flags in commandline operations.
--- additionally, since this is a common operation, it removes the need for `({...})` into `{...}` (reduces clutter).
--- @param t table the table to be concatted into flags.
--- @return string #the table as a string with spaces in between.
local function as_flags(t) return table.concat(t, ' ') end

--- live fuzzy grep
function LiveFuzzyGrep()
    -- local all_flags = { '--hidden', '--column', '--line-number', '--with-filename', '--no-heading', }
    -- local exclude_globs = PrependToEachTableEntry(
    --     { '"!*.class"', '"!*.jar"', '"!*.java.html"', '"!*.git*"' }, '--glob='
    -- )
    local rg_prefix = 'rg --column --line-number --no-heading --color=always --smart-case '
    fzf_wrap {
        source = rg_prefix,
        sink = as_global(function(result)
            local results_table = StringToTable(result, ':')
            vim.cmd('e ' .. results_table[1]) -- 1 is the file path.
            vim.fn.cursor(results_table[2], results_table[3]) -- 2 is the row, 3 is column.
        end),
        options = as_flags {
            '--ansi',
            '--prompt "grep > "',
            '--disabled',
            '--query ""',
            '--delimiter :',
            '--bind "change:reload:sleep 0.1; ' .. rg_prefix .. ' {q} || true"',
        },
    }
end

function LiveBufSelect()
    fzf_wrap {
        source = GetListedBufNames(),
        sink = as_global(function(result) vim.cmd('e ' .. result) end),
        options = as_flags { '--prompt "buffer name > "' },
    }
end

--- @param flags string of flags to pass into git branch. mainly for if you want to use `--all` to show remote branches.
function LiveGitBranchSelection(flags)
    flags = flags or ''
    fzf_wrap {
        -- note that whitespace (3 lines down) needs to be cleaned in order to properly select the branch.
        source = (function()
            local branches = StringToTable(vim.fn.system('git branch --no-color' .. flags), '\n')
            for i, branch in ipairs(branches) do branches[i] = string.gsub(branch, ' ', '') end
            return branches
        end)(),
        sink = as_global(function(result) if (result:find('*')) ~= 1 then vim.cmd('G checkout ' .. result) end end),
        options = as_flags { '--prompt "branch name >"' },
    }
end

function LiveChangesFromPrevCommit()
    fzf_wrap {
        source = (function() return StringToTable(vim.fn.system('git diff HEAD~1 --name-only'), '\n') end)(),
        sink = as_global(function(result) vim.cmd('e ' .. result) end),
        options = as_flags { '--prompt "changed file > "' },
    }
end

--- @see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_documentSymbol
--- todo: fix this..
function LiveDocSymbolFinder()
    fzf_wrap {
        source = (function()
            -- sync response since we're waiting for specific functionality and need the list to populate rg.
            local params = { textDocument = vim.lsp.util.make_text_document_params() }
            local response = vim.lsp.buf_request_sync(0, 'textDocument/documentSymbol', params)

            -- returned table to be searched by fzf.
            local symbols = {}

            -- clear the hashtable used for getting extra details.
            Fzf_hash_table_store = {}
            local symbol_definition_hashset = {}

            -- response is a table with a new index each time. using pairs grabs this response.
            for _, response_table in pairs(response) do

                -- iterate through everything the response has given us.
                for _, r in ipairs(response_table.result) do
                    -- name, range, selectionRange, detail, children, kind
                    -- RecursivePrint(r)
                    local line_to_search = table.concat({ '[' .. GetLSPKind(r.kind) .. ']', r.name }, ' ')
                    symbol_definition_hashset[r.name] = true

                    -- store the originally found table in a hash table where the key is
                    -- is the line that will show up in the fzf search.
                    Fzf_hash_table_store[line_to_search] = r
                    table.insert(symbols, line_to_search)

                    -- table input -> get all fields
                    --   table input has children?
                    --      yes -> repeat function inside child.

                    --- @param table_to_recurse table should be `r` in here.
                    local function extract(table_to_recurse)

                        -- if it has children we want to get them as well.
                        if table_to_recurse.children then
                            for _, child in ipairs(table_to_recurse.children) do

                                -- if the child hasn't been seen before.
                                if not symbol_definition_hashset[table_to_recurse.name] then

                                    -- keep track of what's been seen.
                                    symbol_definition_hashset[table_to_recurse.name] = true

                                    -- add to our result.
                                    local line_to_search_x = table.concat({
                                        '[' .. GetLSPKind(table_to_recurse.kind) .. ']',
                                        table_to_recurse.name,
                                    }, ' ')
                                    Fzf_hash_table_store[line_to_search_x] = table_to_recurse
                                    table.insert(symbols, line_to_search_x)
                                end

                                -- check if there are more children to investigate.
                                if child.children then extract(child) end

                            end
                        end
                    end

                    extract(r)
                end

            end
            return symbols
        end)(),

        sink = function(grep_result)
            local details = Fzf_hash_table_store[grep_result]

            -- need plus one since LSP result is indexed starting at 0.
            vim.fn.cursor(details.range.start.line + 1, details.range.start.character + 1)
        end,
        options = as_flags { '--prompt "symbol > "' },
    }
end

nnoremap('<leader>g', ':lua LiveFuzzyGrep()<enter>')
nnoremap('<leader>b', ':lua LiveBufSelect()<enter>')
nnoremap('<leader>B', ':lua LiveGitBranchSelection()<enter>')
nnoremap('<leader>h', ':lua LiveChangesFromPrevCommit()<enter>')
nnoremap('go', ':lua LiveDocSymbolFinder()<enter>')
nnoremap('<leader>f', ':FZF<enter>')
