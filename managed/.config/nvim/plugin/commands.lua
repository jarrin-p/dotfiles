--- @author jarrin-p
--- @file `commands.lua`
-- changes current directory to the root of the git repository.
Exec([[ command! GT execute 'cd' fnameescape(FugitiveWorkTree())]], false)

-- loads the Sessiom.vim from the root of the git directory if in one.
Exec([[ command! LG lua LoadGitSession()]], false)

-- alias for opening quickfix list to a new tab.
Exec([[ command! CO tabnew | copen | only]], false)

-- vim: fdm=marker foldlevel=0
