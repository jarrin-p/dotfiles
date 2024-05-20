(local os (require :os))
(local tableMerge (fn [from onto]
                    (each [key val (pairs from)] (tset onto key val))
                    onto))

(local M (let [level-map {:ERROR 4 :WARN 3 :INFO 2 :DEBUG 1}
               env-level (or (os.getenv :DOTFILES_LOG_LEVEL) :WARN)
               level (. level-map env-level)
               write (fn [level-check details logger to-out]
                       (when (and (<= logger.level level-check) (. logger.allowed-loggers logger.logger))
                         (let [output (.. logger.logger " "
                                          (table.concat details " ")
                                          (tostring to-out))]
                           (print output)
                           output)))]
           {: level
            :logger :logger
            :allowed-loggers {:init :true}
            :dbg (partial write level-map.DEBUG ["DEBUG "])
            :info (partial write level-map.INFO ["INFO "])
            :warn (partial write level-map.WARN ["WARN "])
            :err (partial write level-map.ERROR ["ERROR "])}))
M

; (local t (partial (fn [x name] (print (.. :x " " x)) (print (.. :name " " name))) :other))
; (t :jarrin)
