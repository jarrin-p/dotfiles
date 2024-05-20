(let [{: apply-opacity-transition} (require :hex-tool)
      green "#a9b665" ;; test color.
      background "#282828"
      expected "#3C3E32"]
  (assert (= expected (apply-opacity-transition green background .15))))
