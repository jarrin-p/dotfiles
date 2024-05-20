(let [{: setup} (require :neoscroll)
      settings {;; All these keys will be mapped to their corresponding default scrolling animation
                :mappings [:<C-u>
                           :<C-d>
                           :<C-b>
                           :<C-f>
                           :<C-y>
                           :<C-e>
                           :zt
                           :zz
                           :zb]
                ;; Hide cursor while scrolling
                :hide_cursor true
                ;; Stop at <EOF> when scrolling downwards
                :stop_eof true
                ;; Stop scrolling when the cursor reaches the scrolloff margin of the file
                :respect_scrolloff false
                ;; The cursor will keep on scrolling even if the window cannot scroll further
                :cursor_scrolls_alone true
                ;; Default easing function
                :easing_function nil
                ;; Function to run before the scrolling animation starts
                :pre_hook nil
                ;; Function to run after the scrolling animation ends
                :post_hook nil
                ;; Disable "Performance Mode" on all buffers.
                :performance_mode false}]
  (setup settings))

{}
