(local io (require :io))
(local os (require :os))
(local log (require :logs))

;; flags for different state.
(var update-checksum-file false)
(var run-full-compile false)

(let [match-pattern "(%w+)  ([%w./_-]+)" ;; gets list of md5sums for each file.
      md5-filename :md5sum.check
      current-md5-lines (io.popen "find . -name '*.fnl' | xargs -I% md5sum %"
                                  :r)
      ;; reads local state file to check for changes.
      validation-md5-lines (match (io.open md5-filename :r) file file
                             (nil err) (set run-full-compile true))
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
  (let [compile-fnl (fn [file]
                      (os.execute (.. "fennel --compile " file " > "
                                      (file:sub 1 (- (length file) 4)) :.lua)))
        ;; re-compiles all on edge conditions such as new files added or errors.
        compilation-strategy (if run-full-compile
                                 (fn [file md5]
                                   (print "running full compile")
                                   (compile-fnl file))
                                 (fn [file md5] ; compile only different files.
                                   (when (not= md5 (. validation file))
                                     (set update-checksum-file true) ; todo - cleanup redundant check.
                                     (print (.. "found changed file. compiling "
                                                file))
                                     (compile-fnl file))))]
    (when (not= (length current) (length validation))
      (set run-full-compile true))
    (each [file md5 (pairs current)]
      (compilation-strategy file md5))
    (when (or update-checksum-file run-full-compile)
      (os.execute (.. "find . -name '*.fnl' | xargs -I% md5sum % > "
                      md5-filename)))))
