(local io (require :io))
(local os (require :os))
(local nvim-config-path (.. (os.getenv :HOME) :/.config/nvim))
;; in the future if I want to load additional fennel
; (local fennel-base (require :fennel))
; (local fennel (fennel-base.install))
; (set package.path (.. nvim-config-path "/?.fnl;" package.path))
; (var log (require :logs))

;; todo: recompile when lua files are found to be changed as well.
;; todo: persist exclude list to export of md5sum.check

(local map-length (fn [t]
                    (accumulate [i 0 _ _ (pairs t)] (+ i 0))))

(local get-path-tail
       (fn [path]
         (let [pattern ".+/(.+)" ; everything up until first slash.
               normalized-path (if (string.match path "\\./.+") path
                                   (.. "./" path))]
           (string.match normalized-path pattern))))

;; note: this will exclude ./a/x.tail and ./b/x.tail
(local exclude
       (fn [target exclude-table]
         (collect [file-path val (pairs target)]
           (let [path-tail (get-path-tail file-path)
                 is-in-excluded (?. exclude-table path-tail)]
             (if is-in-excluded nil (values file-path val))))))

(local exclude-list {:fennel_aot_compile.fnl true})

;; flags for different state.
(var update-checksum-file false)
(var run-full-compile false)

(let [match-pattern "(%w+)  ([%w./_-]+)" ;; gets list of md5sums for each file.
      config-path (let [real-path-handle (io.popen (.. "realpath "
                                                       nvim-config-path)
                                                   :r)
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
                            (if md5-in
                                (collect [line (md5-in:lines)]
                                  (let [(md5hash file-path) (line:match match-pattern)]
                                    (values file-path md5hash)))
                                {}))
      current (exclude (load-md5-into-table current-md5-lines) exclude-list)
      validation (load-md5-into-table validation-md5-lines)
      compile-fnl (fn [file-name]
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
                    " -name '*.fnl' | xargs -I% md5sum % > " md5-filepath))))
