(local ceil (. (require :math) :ceil))
(local hex-to-base2 {:0 0
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
                     :f 15})

;; formerly to_hex_table
(local base2-to-hex {0 :0
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
                     15 :F})

(fn hex-to-rgb [hex index]
  "
  hex: string
      r, g, or b of the hexcode.

  returns
      numerical (0-255) representation of hex value.
  "
  (. hex-to-base2 (hex:sub index index)))

(fn rgb-to-hex [val]
  "
  val: number
      r, g, or b numerical value (0-255).

  returns
      hex representation of numerical value.
  "
  (let [ones (% val 16)
        tens (/ (- val ones) 16)]
    (.. (. base2-to-hex tens) (. base2-to-hex ones))))

(fn apply-opacity [front behind opacity]
  (let [opacity-front (* opacity front)
        opacity-behind (* (- 1 opacity) behind)]
    (-> (+ opacity-front opacity-behind) (ceil))))

(fn convert-to-rgb [hex index]
  (let [tens (hex-to-rgb hex index)
        ones (hex-to-rgb hex (+ index 1))]
    (+ (* tens 16) ones)))

(fn apply-opacity-to-tables [front behind opacity]
  (collect [k _ (ipairs front)]
    (apply-opacity (. front k) (. behind k) opacity)))

(fn get-hex-as-rgb-table [hex]
  {:r (convert-to-rgb hex 2)
   :g (convert-to-rgb hex 4)
   :b (convert-to-rgb hex 6)})

(fn convert-rgb-table-to-hex [rgb]
  "
  rgb: table
      r: number
      g: number
      b: number

  returns: string
      hex representation of the rgb table.
  "
  (let [{: r : g : b} (collect [k v (pairs rgb)]
                        (values k (rgb-to-hex v)))]
    (.. "#" r g b)))

(fn apply-opacity-transition [front back opacity]
  (-> (apply-opacity-to-tables (get-hex-as-rgb-table front)
                               (get-hex-as-rgb-table back) opacity)
      (convert-rgb-table-to-hex)))

{: apply-opacity-transition}
