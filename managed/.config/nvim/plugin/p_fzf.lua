local util = require 'util'
util.nnoremap('<leader>f', ':FZF -q !^.\\ !/.\\ <enter>')

--- basically an alias. wraps the `fzf#wrap` function to be conveniently called from lua.
--- @param opts table lua table equivalent to the table accepted by `fzf#wrap`.
local function fzf_wrap(opts)
    vim.fn['fzf#run'](vim.fn['fzf#wrap'](opts))
end

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
local function as_flags(t)
    return table.concat(t, ' ')
end

function FuzzyGrep()
    local rg_prefix = 'rg ' .. as_flags {
        '--hidden',
        '--column',
        '--line-number',
        '--no-heading',
        '--color=always',
        '--smart-case',
        '--glob=\'!*.git\'',
    } .. ' '
    fzf_wrap {
        source = rg_prefix .. '""', -- searches everything on init.
        sink = as_global(function(result)
            local results_table = util.string_to_table(result, ':')
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
util.nnoremap('<leader>g', ':lua FuzzyGrep()<enter>')

function BufSelect()
    fzf_wrap {
        source = util.get_listed_bufnames(),

        --- @param result string absolute path to the result.
        sink = as_global(function(result)
            vim.cmd('e ' .. result)
        end),
        options = as_flags { '--prompt "buffer name > "' },
    }
end
util.nnoremap('<leader>b', ':lua BufSelect()<enter>')

--- @param flags string of flags to pass into git branch. mainly for if you want to use `--all` to show remote branches.
function BranchSelect(flags)
    flags = flags or ''
    fzf_wrap {
        source = 'git branch --no-color | tr -d " " | sort -r -' .. flags,
        sink = as_global(function(result)
            if (result:find('*')) ~= 1 then
                vim.cmd('G checkout ' .. result)
            end
        end),
        options = as_flags { '--prompt "branch name > "' },
    }
end
util.nnoremap('<leader>B', ':lua BranchSelect()<enter>')

function SetBranchToDiff()
    vim.g.BranchToDiff = vim.fn.input('enter branch to diff against: ')
end
function BranchFileDiff()
    local source
    if (pcall(function()
        source = 'git diff ' .. vim.g.BranchToDiff .. ' --name-only'
    end)) then
        fzf_wrap {
            source = source,
            sink = as_global(function(result)
                vim.cmd('GT') -- cds to the top of the git repo.
                vim.cmd('e ' .. result) -- edits the file.
            end),
            options = as_flags { '--prompt "(' .. vim.g.BranchToDiff .. ') changed file > "' },
        }
    else
        SetBranchToDiff()
        BranchFileDiff()
    end
end
util.nnoremap('<leader>h', ':lua BranchFileDiff()<enter>')
util.nnoremap('<leader>H', ':lua SetBranchToDiff()<enter>')

--- @see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_documentSymbol
--- todo: fix this..
-- function SymbolSelect()
--     fzf_wrap {
--         source = as_global(function()
--             -- sync response since we're waiting for specific functionality and need the list to populate rg.
--             -- local params = { textDocument = vim.lsp.util.make_text_document_params() }
--             -- local response = vim.lsp.buf_request_sync(0, 'textDocument/documentSymbol', params)
--         end),
-- 
--         sink = function(grep_result)
--             -- local details = Fzf_hash_table_store[grep_result]
-- 
--             -- need plus one since LSP result is indexed starting at 0.
--             -- vim.fn.cursor(details.range.start.line + 1, details.range.start.character + 1)
--         end,
--         options = as_flags { '--prompt "symbol > "' },
--     }
-- end
-- nnoremap('go', ':lua SymbolSelect()<enter>')
