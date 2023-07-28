(local io (require :io))
(local os (require :os))
(local popen io.popen)
(local nvim-config-path (.. (os.getenv :HOME) :/.config/nvim))
;; in the future if I want to load additional fennel
; (local fennel-base (require :fennel))
; (local fennel (fennel-base.install))
; (set package.path (.. nvim-config-path "/?.fnl;" package.path))
; (var log (require :logs))

;; todo: recompile when lua files are found to be changed as well.
;; todo: persist exclude list to export of md5sum.check

(local map-length (fn [t]
                    (accumulate [i 0 _ _ (pairs t)] (+ i 1))))

(local destructure-path
       (fn [path]
         (let [normalized-path (-> path
                                   (#(if (string.match $1 "^./")
                                         $1
                                         (.. "./" $1)))
                                   (#(string.gsub $1 "/$" "")))
               (dir basename) (string.match normalized-path "(%./.*)/(.*)")
               (file-name extension) (string.match basename "(.*)%.(.*)")]
           {: basename : dir : file-name : extension})))

;; note: this will exclude ./a/x.tail and ./b/x.tail
(local exclude
       (fn [target exclude-table]
         (collect [file-path val (pairs target)]
           (let [path-tail (. (destructure-path file-path) :basename)
                 is-in-excluded (?. exclude-table path-tail)]
             (if is-in-excluded nil (values file-path val))))))

(local allow
       (fn [target allow-table]
         (collect [file-path val (pairs target)]
           (if (. allow-table file-path) (values file-path val) nil))))

(local exclude-list {:fennel_aot_compile.fnl true :nvim-macros.fnl true})

;; flags for different state.
(var update-checksum-file false)
(var run-full-compile false)

;; TODO finish moving destructured file paths into normalized structure
;; TODO pull path related things into utils.
(let [md5-match-pattern "(%w+)  ([%w./_-]+)"
      ;; gets list of md5sums for each file.
      config-realpath (with-open [real-path (io.popen (.. "realpath "
                                                          nvim-config-path)
                                                      :r)]
                        (real-path:read))
      md5-filepath (.. config-realpath "/" :md5sum.check)
      line-as-hashset-key-iter (fn [iter]
                                 (collect [line iter]
                                   (values line (destructure-path line))))
      split-hash-iter (fn [iter]
                        (collect [line iter]
                          (let [(md5hash file-path) (line:match md5-match-pattern)
                                destructured (destructure-path file-path)]
                            (values file-path md5hash))))
      build-table-from-file-cmd (fn [read-method cmd iterator-applier]
                                  (with-open [handle (read-method cmd :r)]
                                    (case handle found
                                      (iterator-applier (found:lines))
                                      (nil err)
                                      (values nil err))))
      current-md5-lines (-> (build-table-from-file-cmd io.popen
                                                       (.. "find "
                                                           config-realpath
                                                           " -name '*.fnl' | xargs -I% md5sum %")
                                                       split-hash-iter)
                            (exclude exclude-list))
      current-lua-files (-> (build-table-from-file-cmd io.popen
                                                       (.. "find "
                                                           config-realpath
                                                           " -name '*.lua'")
                                                       line-as-hashset-key-iter)
                            (exclude exclude-list)
                            (allow current-md5-lines))
      validation-md5-lines (build-table-from-file-cmd io.open md5-filepath
                                                      split-hash-iter)
      compile-fnl (fn [file-name]
                    (os.execute (.. "fennel --compile " file-name " > "
                                    (file-name:sub 1 (- (length file-name) 4))
                                    :.lua)))
      ;; re-compiles all on edge conditions such as new files added or errors.
      compile-all (fn [file-name md5]
                    (compile-fnl file-name))
      compile-diff (fn [file-name md5]
                     (when (not= md5 (. validation-md5-lines file-name))
                       (set update-checksum-file true)
                       (compile-fnl file-name)))
      fnl-count (map-length current-md5-lines)
      lua-count (map-length current-lua-files)
      validation-count (map-length validation-md5-lines)
      aot-compile (fn [compilation-strategy file-map]
                    (each [file-name md5 (pairs file-map)]
                      (compilation-strategy file-name md5)))]
  (-> (match [fnl-count lua-count validation-count]
        [x x x] compile-diff
        [x y z] compile-all)
      (aot-compile current-md5-lines))
  (when (or update-checksum-file)
    (os.execute (.. "find " config-realpath
                    " -name '*.fnl' | xargs -I% md5sum % > " md5-filepath))))
