local util = require 'util'
vim.bo.tabstop = 2

local group_id = vim.api.nvim_create_augroup('ScalaGroup', { clear = true })

-- runs `spotlessApply` at the top level of the git repository.
util.exec([[ command! SA !cd $(git rev-parse --show-toplevel); gradle spotlessApply ]], false)

-- assumes spotlessApply is apart of gradle.build.
vim.api.nvim_create_autocmd({ 'BufWritePost' }, { pattern = { '*.java' }, command = 'silent SA', group = group_id })
