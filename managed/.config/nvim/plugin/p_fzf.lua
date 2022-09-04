--- wraps the api call into something more friendly to `lua`. uses `fzf#wrap` to use the system's default values if arguments aren't provided.
--- @param source_cmd string|function the string grep command whose result will be used for input.
--- @param sink_fn function the callback that will be used for handling the result.
--- @param fzf_opts? string options that will be passed to fzf.
function FzfWrapper(source_cmd, sink_fn, fzf_opts)
    vim.fn['fzf#run'](
        vim.fn['fzf#wrap'](
            { source = source_cmd, sink = sink_fn, options = fzf_opts }
        )
    )
end

--- fuzzy find internal or external things.
--- @param build_cmd_opts rg_cmd_opts options to be used for the BuildRipGrepCommand function.
--- @param result_handler_fn function vim.g.function takes a string, will be executed on the selected entry.
--- @param fzf_opts table options that will be passed to fzf.
function FzfSearch(build_cmd_opts, result_handler_fn, fzf_opts)
    vim.g.FzfSearchFn = result_handler_fn -- the fzf sink needs to be wrapped into a global function to be accessed.
    FzfWrapper(
        BuildRipGrepCommand(build_cmd_opts), vim.g.FzfSearchFn,
            table.concat(fzf_opts, ' ')
    )
end

function LiveFuzzyGrep()
    FzfSearch(
        {
            grep_args = function()
                local all_flags = {
                    '--hidden', '--column', '--line-number', '--with-filename',
                    '--no-heading',
                }
                local exclude_globs = PrependToEachTableEntry(
                    { '"!*.class"', '"!*.jar"', '"!*.java.html"', '"!*.git*"' },
                        '--glob='
                )
                for _, flag in ipairs(exclude_globs) do
                    table.insert(all_flags, flag)
                end
                return all_flags
            end,
        }, function(grep_result)
            local grep_result_as_table = SplitStringToTable(grep_result, ':')
            vim.cmd('e ' .. grep_result_as_table[1]) -- 1 is the file path.
            vim.fn.cursor(grep_result_as_table[2], grep_result_as_table[3]) -- 2 is the row, 3 is column.
        end, { '--prompt "test"' }
    )
end

function LiveBufSelect()
    FzfSearch(
        { t = GetListedBufNames }, function(grep_result)
            vim.cmd('e ' .. grep_result)
        end
    )
end

--- @param all_flag boolean whether or not to pass `-a` flag to git call.
function LiveGitBranchSelection(all_flag)
    local all
    if all_flag == true then
        all = ' -a'
    else
        all = ''
    end
    FzfSearch(
        {
            t = function()
                -- runs a system command to get all git branches then splits them into a table based on newlines.
                local branches = SplitStringToTable(
                    vim.fn.system(
                        'git branch --no-color' .. all
                    ), '\n'
                )

                -- cleans out whitespaces
                for i, branch in ipairs(branches) do
                    branches[i] = string.gsub(branch, ' ', '')
                end
                return branches
            end,
        }, function(grep_result)
            if (grep_result:find('*')) == 1 then
                print('already on this branch!')
            else
                vim.cmd('G checkout ' .. grep_result)
            end
        end
    )
end

function LiveChangesFromPrevCommit()
    FzfSearch(
        {
            t = function()
                local files = SplitStringToTable(
                    vim.fn.system(
                        'git diff HEAD~1 --name-only'
                    ), '\n'
                )
                return files
            end,
        }, function(grep_result)
            vim.cmd('e ' .. grep_result)
        end
    )
end
--- @see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_documentSymbol
function LiveDocSymbolFinder()
    FzfSearch(
        {
            t = function()
                -- TODO add check for if the server has loaded yet.
                -- sync response since we're waiting for specific functionality and need the list to populate rg.
                local params = {
                    textDocument = vim.lsp.util.make_text_document_params(),
                }
                local response = vim.lsp.buf_request_sync(
                    0, 'textDocument/documentSymbol', params
                )

                -- returned table to be searched by fzf.
                local symbols = {}

                -- TODO generalize this as an argument into the FzfSearch function.
                -- clear the hashtable used for getting extra details.
                Fzf_hash_table_store = {}

                local symbol_definition_hashset = {}

                -- response is a table with a new index each time. using pairs grabs this response.
                for _, response_table in pairs(response) do

                    -- iterate through everything the response has given us.
                    for _, r in ipairs(response_table.result) do
                        -- name, range, selectionRange, detail, children, kind
                        -- RecursivePrint(r)
                        local line_to_search = table.concat(
                            { '[' .. GetLSPKind(r.kind) .. ']', r.name }, ' '
                        )
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
                                        local line_to_search_x = table.concat(
                                            {
                                                '['
                                                    .. GetLSPKind(
                                                        table_to_recurse.kind
                                                    ) .. ']',
                                                table_to_recurse.name,
                                            }, ' '
                                        )
                                        Fzf_hash_table_store[line_to_search_x] = table_to_recurse
                                        table.insert(symbols, line_to_search_x)
                                    end

                                    -- check if there are more children to investigate.
                                    if child.children then
                                        extract(child)
                                    end

                                end
                            end
                        end

                        extract(r)
                    end

                end
                return symbols
            end,
        }, function(grep_result)
            local details = Fzf_hash_table_store[grep_result]

            -- need plus one since LSP result is indexed starting at 0.
            vim.fn.cursor(
                details.range.start.line + 1, details.range.start.character + 1
            )
        end
    )
end

nnoremap('<leader>g', ':lua LiveFuzzyGrep()<enter>')
nnoremap('<leader>b', ':lua LiveBufSelect()<enter>')
nnoremap('<leader>B', ':lua LiveGitBranchSelection()<enter>')
nnoremap('<leader>h', ':lua LiveChangesFromPrevCommit()<enter>')

-- replaces with interactive find. didn't like that document_symbol
-- sends to quickfix list because it force opens and is hard to view.
nnoremap('go', ':lua LiveDocSymbolFinder()<enter>')
-- nnoremap('go', ':lua vim.lsp.buf.document_symbol()<enter>')
nnoremap('<leader>f', ':FZF<enter>')
