(let [iabbrev {"\\and\\" "∧"
               "\\or\\" "∨"
               "\\bullet\\" "•"
               "\\.\\" "•"
               "\\in\\" "∈"
               "\\element\\" "∈"
               "\\delta\\" "δ"
               "\\shrug\\" "¯\\_(ツ)_/¯"
               "\\idk\\" "ヽ(゜～゜o)ノ"
               "\\crying\\" "(╯︵╰,)"
               "\\cat\\" "ฅ^•ﻌ•^ฅ"
               "\\success\\" "(•̀ᴗ•́)و"}]
  (each [k v (pairs iabbrev)]
    (vim.cmd.iabbrev (.. k " " v))))

{}
