; useful reference by @wintershadows
; https://git.sr.ht/~wintershadows/dotfiles/tree/356fb9cd/item/.config/nvim/lua/fennel-init.lua
(local fennel (. _G :fennel_base))
(local log (require :logs))
(tset log :logger :init)
(fn as-runtime-paths [paths]
  (icollect [_ path (ipairs paths)] (vim.api.nvim_get_runtime_file path false)))

(fn runtime-searcher [name]
  (let [base-name (string.gsub name "%." "/")
        path-list [(.. :fennel base-name :.fnl)]]
    (each [_ result (ipairs (as-runtime-paths path-list))]
      (log:info (.. "name: " name))
      (if (> (length result) 0)
          ((fn [] fennel.dofile (. result 1)) (log:info (.. "name: " name)) (log:info (. result 1)))))))

(table.insert package.loaders fennel.searcher)
(table.insert package.loaders 2 runtime-searcher)
