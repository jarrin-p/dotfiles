;; disable swapfiles for testing.
;; currently failures will leave lingering swap files which makes re-running tests a pain.
(set vim.o.swapfile false)
(local utils (require :utils))

;; load file
(vim.cmd "e tests/resources/test_json_fmt.json")

;; load resource into buffer.
(vim.cmd :FF)

; command we're actually trying to test.
(let [lines (vim.api.nvim_buf_get_lines 0 0 999 false)]
  (each [index line (ipairs lines)]
    (case index
      1 (assert (= line "{"))
      2 (assert (= line "  \"hello\": \"world\""))
      3 (assert (= line "}"))
      _ ((print "unexpected table index. exiting") (vim.cmd :qa!)))))

;; check buffers
(let [result (utils.get_listed_bufnames)] ; command we're actually trying to test.
  (print utils.get_listed_bufnames)
  (print result)
  (each [index bufname (ipairs result)]
    (print bufname)))

;; don't save the file, we just want to make sure it formats properly.
(vim.cmd :qa!)

{}
