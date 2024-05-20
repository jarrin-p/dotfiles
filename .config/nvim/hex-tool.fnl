(let [{: ceil} (require :math)
      hex-to-base2 {:0 0
                    :1 1
                    :2 2
                    :3 3
                    :4 4
                    :5 5
                    :6 6
                    :7 7
                    :8 8
                    :9 9
                    :A 10
                    :B 11
                    :C 12
                    :D 13
                    :E 14
                    :F 15
                    :a 10
                    :b 11
                    :c 12
                    :d 13
                    :e 14
                    :f 15}
      base2-to-hex {0 :0
                    1 :1
                    2 :2
                    3 :3
                    4 :4
                    5 :5
                    6 :6
                    7 :7
                    8 :8
                    9 :9
                    10 :A
                    11 :B
                    12 :C
                    13 :D
                    14 :E
                    15 :F}
      apply-opacity (fn [front behind opacity]
                      (let [opacity-front (* opacity front)
                            opacity-behind (* (- 1 opacity) behind)]
                        (-> (+ opacity-front opacity-behind) (ceil))))
      apply-opacity-transition (fn [front back opacity]
                                 (let [apply-opacity-to-tables (fn [front behind opacity] 
                                                                 {}
                                                                 )
                                       get-hex-as-rgb-table (fn [] {})
                                       convert-rgb-table-to-hex (fn [] {})]
                                   (-> (apply-opacity-to-tables (get-hex-as-rgb-table front)
                                                                (get-hex-as-rgb-table back)
                                                                opacity)
                                       (convert-rgb-table-to-hex))))]
  {: apply-opacity-transition})
