(let [{: getenv : execute} (require :os)
      dotx-path (getenv :DOTX_CONFIG_LOCATION)]
  (do
    (execute (.. "cd " dotx-path "/.config && make build > /dev/null"))
    (set package.path (.. package.path ";" dotx-path :/.config/nvim/?.lua))))

(let [{: linear-search} (require :pack.lines.util.options)]
  (assert (= (linear-search [:a :b :c :d :e :f] :e) 5)))
