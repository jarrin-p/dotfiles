(fn load-once [key load-fn]
  (let [{: info} (require :utils.log)
        lsps (case _G.loaded
               nil (do
                     (info #"load-once.fnl: initializing global loading table.")
                     {})
               x x)]
    (set _G.loaded (do
                     (case (. lsps key)
                       nil (do
                             (load-fn)
                             (tset lsps key true))
                       true (do
                              (info #"load-once.fnl: function for given key has already been loaded.")))
                     lsps))))

{: load-once}
