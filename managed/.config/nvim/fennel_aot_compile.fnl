(local io (require :io))
(local os (require :os))
(local log (require :logs))

(local map-length (fn [t]
                    (accumulate [i 0 _ _ (pairs t)] (+ i 0))))

;; flags for different state.
(var update-checksum-file false)
(var run-full-compile false)

(let [match-pattern "(%w+)  ([%w./_-]+)" ;; gets list of md5sums for each file.
      config-path (let [path (.. (os.getenv :HOME) :/.config/nvim)
                        real-path-handle (io.popen (.. "realpath " path) :r)
                        real-path (real-path-handle:read)]
                    (real-path-handle:close)
                    real-path)
      md5-filepath (.. config-path "/" :md5sum.check)
      current-md5-lines (io.popen (.. "find " config-path
                                      " -name '*.fnl' | xargs -I% md5sum %")
                                  :r)
      ;; reads local state file to check for changes.
      validation-md5-lines (match (io.open md5-filepath :r) file file
                             (nil err) (print :could-not-find-existing-md5))
      ;; converts a set of lines into a lua table.
      load-md5-into-table (fn [md5-in]
                            (local file-md5-map {})
                            (when md5-in
                              (each [line (md5-in:lines)]
                                (each [md5hash file-path (line:gmatch match-pattern)]
                                  (tset file-md5-map file-path md5hash)))
                              (md5-in:close))
                            file-md5-map) ;; hashes
      current (load-md5-into-table current-md5-lines)
      validation (load-md5-into-table validation-md5-lines)]
  (let [compile-fnl (fn [file-name]
                      (print (.. "detected file change: compiling to lua "
                                 file-name))
                      (os.execute (.. "fennel --compile " file-name " > "
                                      (file-name:sub 1 (- (length file-name) 4))
                                      :.lua)))
        ;; re-compiles all on edge conditions such as new files added or errors.
        compilation-strategy (if run-full-compile
                                 (fn [file-name md5]
                                   (compile-fnl file-name))
                                 (fn [file-name md5] ; compile only changed files.
                                   (when (not= md5 (. validation file-name))
                                     (set update-checksum-file true) ; todo - cleanup redundant check.
                                     (compile-fnl file-name))))]
    (when (not= (map-length current) (map-length validation))
      (print :found-difference-between-file-counts)
      (set run-full-compile true))
    (each [file-name md5 (pairs current)]
      (compilation-strategy file-name md5))
    (when (or update-checksum-file run-full-compile)
      (os.execute (.. "find " config-path
                      " -name '*.fnl' | xargs -I% md5sum % > " md5-filepath)))))
