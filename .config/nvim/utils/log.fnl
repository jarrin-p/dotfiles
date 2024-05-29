(fn write [level-priority log-level output-prefix out]
  "
  baseline method that different log level commands are build out of.
  work in progress. just trying to keep it simple for now.

  example
    (let [{: info} (require <this-file>)] (info #:hello-world))

  level-priority: int
    the numerical quantification of a given log level.

  log-level: int
    the current system's log level to be used for comparison, as a number.
    typically this should be already applied as part of the partial.

  output-prefix: string
    the text that will go before the actual log.

  out: function
    a function that supplies the output. works good with # to create
    identity fns for strings.
  "
  (when (<= log-level level-priority)
    (print (.. output-prefix (out)))))

(let [{: getenv} (require :os)
      level-map {:ERROR 4 :WARN 3 :INFO 2 :DEBUG 1}
      log-level-txt (or (getenv :DOTX_LOG_LEVEL) :WARN)
      log-level-numeric (. level-map log-level-txt)]
  {:dbg (partial write level-map.DEBUG log-level-numeric "DEBUG - ")
   :info (partial write level-map.INFO log-level-numeric "INFO - ")
   :warn (partial write level-map.WARN log-level-numeric "WARN - ")
   :err (partial write level-map.ERROR log-level-numeric "ERROR - ")})
