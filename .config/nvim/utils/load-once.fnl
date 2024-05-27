(fn load-once [key load-fn]
  (let [{: info} (require :utils.log)
        lsps (case _G.loaded
               nil (do
                     (info #"initializing global loading table.")
                     {})
               x x)]
    (set _G.loaded (do
                     (case (. lsps key)
                       nil (do
                             (load-fn)
                             (tset lsps key true))
                       false (do
                               (print :loading-registered-fn))
                       true (do
                              (info #"function for given key has already been loaded.")))
                     lsps))))

{: load-once}
