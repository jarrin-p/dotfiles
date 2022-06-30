--- @author jarrin-p {{{
--- @description commands are set here. }}}

require 'Util'


-- runs `spotlessApply` at the top level of the git repository.
-- TODO install `spotlessApply` as a standalone.
Exec([[ command SA !cd $(git rev-parse --show-toplevel); gradle spotlessApply ]], false)

-- runs `terraform fmt` on the current file.
Exec([[ command TFF !terraform fmt % ]], false)

-- runs `terraform fmt` on the current file.
Exec([[ command BLACK !black % ]], false)

-- changes current directory to the root of the git repository.
Exec([[ command GT execute 'cd' fnameescape(FugitiveWorkTree())]], false)

-- changes current directory to the root of the git repository.
Exec([[ command LG lua LoadGitSession()]], false)

-- vim: fdm=marker foldlevel=0
