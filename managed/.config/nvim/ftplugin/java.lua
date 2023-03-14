local util = require 'util'
local project_name
if vim.fn.FugitiveIsGitDir() == 1 then
    project_name = vim.fn.fnamemodify(vim.fn.FugitiveWorkTree(), ':p:h:t')
else
    project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
end

-- language server settings
local config = {
    cmd = { 'jdtlsw' },
    root_dir = vim.fs.dirname(vim.fs.find({ '.gradlew', '.git', 'mvnw' }, { upward = true })[1]),
    settings = {
        java = { format = { settings = { url = 'https://google.github.io/styleguide/intellij-java-google-style.xml' } } },
    },
}
require('jdtls').start_or_attach(config)

vim.bo.tabstop = 2
vim.wo.foldlevel = 1
vim.wo.foldnestmax = 4

util.exec([[ command! SA !cd $(git rev-parse --show-toplevel); gradle spotlessApply ]], false)

local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require('luasnip.util.events')
-- local ai = require('luasnip.nodes.absolute_indexer')
-- local fmt = require('luasnip.extras.fmt').fmt
-- local m = require('luasnip.extras').m
-- local lambda = require('luasnip.extras').l
-- local postfix = require('luasnip.extras.postfix').postfix
-- local select_choice = require 'luasnip.extras.select_choice'
ls.cleanup() -- clears all snippets

ls.add_snippets('java', {
    s('print', -- System.out.println()
    { t({ 'System.out.println(' }), i(0), t { ');' } }),
    s('log.i', -- log.info
    { t { 'log.info("' }, i(0), t { '");' } }),
    s('log.e', -- log.error
    { t { 'log.error("' }, i(0), t { '");' } }),
    s('@Mapping', -- mapstruct mapping
    { t { '@Mapping(target = "' }, i(1, 'targetName'), t { '", source = "' }, i(0, 'sourceName'), t { '")' } }),
    s('.ase', -- assert equals
    { t { 'assertEquals(' }, i(1, 'expected'), t { ', ' }, i(0, 'valueToCheck'), t { ')' } }),
    s('@fni', { t { '@FunctionalInterface', 'public interface ' }, i(1, 'interfaceName'), t { ' {', '\t', '}' } }),
    s('.interface', { t { 'public interface ' }, i(1, 'interfaceName'), t { ' {' }, t { '\t' }, t { '}' } }),
    s('.class', { t { 'public class ' }, i(1, 'className'), t { ' {' }, t { '\t' }, i(0), t { '}' } }),
})
