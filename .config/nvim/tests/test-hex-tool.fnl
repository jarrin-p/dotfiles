(let [{: apply-opacity-transition} (require :hex-tool)
      green "#a9b665" ;; test color.
      background "#282828"]
  (print (apply-opacity-transition green background .15)))
