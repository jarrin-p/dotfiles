(let [iabbrev {"\\and\\" "∧"
               "\\or\\" "∨"
               "\\bullet\\" "•"
               "\\.\\" "•"
               "\\in\\" "∈"
               "\\element\\" "∈"
               "\\delta\\" "δ"}]
  (each [k v (pairs iabbrev)]
    (vim.cmd.iabbrev (.. k " " v))))

{}
