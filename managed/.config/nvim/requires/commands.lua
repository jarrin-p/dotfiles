--- @author jarrin-p {{{
--- @description commands are set here. }}}
require 'util'

-- runs `spotlessApply` at the top level of the git repository.
Exec(
    [[ command SA !cd $(git rev-parse --show-toplevel); gradle spotlessApply ]],
        false
)

-- changes current directory to the root of the git repository.
Exec([[ command GT execute 'cd' fnameescape(FugitiveWorkTree())]], false)

-- loads the Sessiom.vim from the root of the git directory if in one.
Exec([[ command LG lua LoadGitSession()]], false)

-- vim: fdm=marker foldlevel=0
