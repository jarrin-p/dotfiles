(let [{: apply-opacity-transition} (require :hex-tool)
      green "#a9b665" ;; test color.
      background "#282828"
      expected "#3C3E32"
      actual (apply-opacity-transition green background 0.15)]
  (assert (= expected actual)))

{}
