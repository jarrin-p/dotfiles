require 'Global'

Exec([[ command -nargs=1 NTI let NERDTreeIgnore=<args> ]], false) -- takes an array
Exec([[ command SA !cd $(git rev-parse --show-toplevel); gradle spotlessApply ]], false)
Exec([[ command TFF !terraform fmt % ]], false)
Exec([[ command GT execute 'cd' fnameescape(FugitiveWorkTree())]], false)
