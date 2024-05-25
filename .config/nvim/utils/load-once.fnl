(fn load-once [load-fn]
  (let [lsps (case _G.loaded
               nil {}
               x x)]
    (set _G.loaded (case (. lsps load-fn)
                     nil (do
                           (load-fn)
                           (tset lsps load-fn true)
                           lsps)
                     true (do
                            (print :already-loaded))))))

{: load-once}
