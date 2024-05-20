(local {: ceil} (require :math))

(fn to-hex [val]
  "
  val: number
  returns: string
      hex representation of numerical value.

  note
      the letters in hex must be uppercase.

  see
      https://www.lua.org/manual/5.3/manual.html#pdf-string.format
      https://www.tutorialspoint.com/c_standard_library/c_function_sprintf.htm
  "
  (string.format "%X" val))

(fn to-base10 [val]
  "
  args
      val: string (hex)

  returns: number
      base10 representation of a hexadecimal string.

  see
      https://www.lua.org/manual/5.3/manual.html#pdf-tonumber
  "
  (tonumber val 16))

(fn to-rgb-table [hex]
  "picks out specific values of an rgb hex string and turns it into a table."
  (let [r (hex:sub 2 3)
        g (hex:sub 4 5)
        b (hex:sub 6 7)]
    {: r : g : b}))

(fn transition [fg bg fg-opacity]
  "formula to transition fg to background with opacity value."
  (let [opacity-fg (* fg-opacity fg)
        opacity-bg (* (- 1 fg-opacity) bg)]
    (-> (+ opacity-fg opacity-bg) (ceil))))

(fn apply [fg-hex bg-hex fg-opacity]
  "
  args
      fg-hex: string (hex)
      bg-hex: string (hex)
      fg-opacity: number

  returns: string (hex)
      the new color representing fg with fg-opacity applied on bg.
  "
  (let [fg (to-base10 fg-hex)
        bg (to-base10 bg-hex)]
    (-> (transition fg bg fg-opacity)
        (to-hex))))

(fn apply-opacity-transition [fg-hex bg-hex fg-opacity]
  "
  given two colors and an input, provides a color like a 'transition' to the background.

  args
      fg-hex: string (hex)
      bg-hex: string (hex)
      fg-opacity: float (0 to 1.0)

  returns: string (hex)
      the color used to represent a foreground with 'opacity' on background.
  "
  (let [fg (to-rgb-table fg-hex)
        bg (to-rgb-table bg-hex)
        {: r : g : b} (collect [k _ (pairs fg)]
                        (values k (apply (. fg k) (. bg k) fg-opacity)))]
    (.. "#" r g b)))

(fn get-colorscheme-as-hex [color-group colorgroup-field]
  (let [color-value (. (vim.api.nvim_get_hl_by_name color-group true)
                       colorgroup-field)]
    (.. "#" (string.format "%06x" color-value))))

{: apply-opacity-transition : get-colorscheme-as-hex}
