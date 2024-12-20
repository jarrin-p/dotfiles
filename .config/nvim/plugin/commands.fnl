(fn build-fnl-tbl [key value]
  (.. "\"" key "\" " value " "))

(fn build-lua-tbl [key value]
  (case (key:find "@")
    nil (.. key " = " value ", ")
    _ (.. "[\"" key "\"] = " value ", ")))

(fn serialize [tbl]
  (accumulate [result "" key value (pairs tbl)]
    (let [res (case (type value)
                :table (build-lua-tbl key (.. "{ " (serialize value) " }"))
                :string (build-lua-tbl key (.. "\"" value "\""))
                _ (build-lua-tbl key (tostring value)))]
      (.. result res))))

(fn serialize-fnl [tbl]
  (accumulate [result "" key value (pairs tbl)]
    (let [res (case (type value)
                :table (build-fnl-tbl key (.. "{ " (serialize-fnl value) " }"))
                :string (build-fnl-tbl key (.. "\"" value "\""))
                _ (build-fnl-tbl key (tostring value)))]
      (.. result res))))

(fn set-font-size [opts]
  (let [new-size (+ vim.g.font-size opts.args)]
    (when (> new-size 0)
      (do
        (set vim.g.font-size new-size)
        (set vim.o.guifont (.. vim.g.FontKW vim.g.font_size ""))))))

(let [{: file-format} (require :utils)
      {:nvim_exec exec :nvim_create_user_command add-cmd} vim.api]
  (add-cmd :ConvertAsciiToUnicode
           #(let [{: line1 : line2 : bang} $1
                  sub-cmd (.. "silent! "
                              (if bang "%sno" (.. line1 "," line2 :sno)))]
              (do
                (vim.notify (.. "sub-cmd:" sub-cmd))
                (vim.cmd (.. sub-cmd "/<->/↔/g"))
                (vim.cmd (.. sub-cmd "/ ->/ →/g"))
                (vim.notify "converted from ascii to unicode.")))
           {:range true
            :bang true
            :desc "converts ascii to unicode in a buffer (opinionated)."})
  (add-cmd :ConvertUnicodeToAscii
           #(let [{: line1 : line2 : bang} $1
                  sub-cmd (.. "silent! "
                              (if bang "%sno" (.. line1 "," line2 :sno)))]
              (do
                (vim.cmd (.. sub-cmd "/↔/<->/g"))
                (vim.cmd (.. sub-cmd "/→/->/g"))
                (vim.notify "converted from unicode to ascii.")))
           {:range true
            :bang true
            :desc "converts unicode to ascii in a buffer (opinionated)."})
  (add-cmd :ExportHighlights
           #(do
              (vim.cmd.tabnew)
              (vim.fn.append (vim.fn.line "$")
                             (.. "local colors = { "
                                 (serialize (vim.api.nvim_get_hl 0 {})) " }"))
              (vim.fn.append (vim.fn.line "$")
                             (.. "for k, v in pairs(colors) do vim.api.nvim_set_hl(0, k, v) end")))
           {})
  (add-cmd :ExportHighlightsFennel
           #(let [{: tabnew : FF : FennelSourceBuffer} vim.cmd
                  {: append : line} vim.fn
                  {:nvim_get_hl get-hl :nvim_create_autocmd autocmd} vim.api]
              (do
                (tabnew)
                (append (line "$")
                        (.. "(local colors { " (serialize-fnl (get-hl 0 {}))
                            " })"))
                (append (line "$")
                        (.. "(collect [k v (pairs colors)] (vim.api.nvim_set_hl 0 k v))"))
                (set vim.bo.filetype :fennel)
                (vim.cmd "silent write! /tmp/colors.fnl")
                (FF)
                (autocmd [:BufWritePost]
                         {:callback #(do
                                       (FennelSourceBuffer)
                                       ;; don't delete the command when finished.
                                       false)
                          :desc "automatically sources the color configuration when saving a change to see immediate results."
                          :buffer 0})))
           {:desc "Creates a new buffer containing the current color scheme configuration. Automatically sources on changing colors."})
  (add-cmd :Fennel (fn [opts]
                     (let [{: eval} (require :fennel)]
                       (eval opts.args)))
           {:nargs "?" :desc "Run arbitrary fennel."})
  (add-cmd :FennelSourceBuffer #(let [{: eval} (require :fennel)
                                      lines (vim.api.nvim_buf_get_lines 0 0
                                                                        (vim.fn.line "$")
                                                                        false)]
                                  (do
                                    (-> (icollect [_ v (ipairs lines)]
                                          (let [(val _count) (v:gsub ";;.*" "")]
                                            val))
                                        (table.concat " ")
                                        (eval))
                                    false))
           {:desc "sources the given fennel buffer into neovim."})
  (add-cmd :FF file-format
           {:desc "alias for gggqG. formats entire doc using `formatprg`."})
  (add-cmd :GT #(let [path (-> (vim.fn.FugitiveWorkTree) (vim.fn.fnameescape))]
                  (vim.cmd.lcd path))
           {:desc "'Git Top' (idk). Changes vim's pwd to the root of a git directory if there is one."})
  (add-cmd :GO #(exec "silent !tmux split-window -h -c $(dirname %)" false)
           {:desc "Opens the directory the current file is in, in tmux."})
  ;; alias
  (add-cmd :Info #(vim.cmd.LeanInfoviewToggle)
           {:desc "Lean specific. Alias for LeanInfoviewToggle."})
  (add-cmd :SetFontSize set-font-size
           {:desc "GUI specific. Sets the font size"})
  (add-cmd :SetMakeRunner
           (fn [opts]
             (let [cmd-prefix "tmux send-keys -t {marked} enter escape 'S"
                   cmd-post "' enter"
                   val opts.args]
               (set vim.o.makeprg (.. cmd-prefix val cmd-post))))
           {:nargs "?"
            :desc "Sets makeprg, but wrapped in a tmux command that will send the command to the marked pane. Mostly a convenience for not wanting to rewire the muscle memory of using `make`"})
  ;; (add-cmd :ShowDiags #(let [
  ;;                            diags (vim.diagnostic.get)
  ;;                            buf (vim.api.nvim_create_buf true true)]
  ;;                        (do
  ;;                          (vim.cmd (.. "vsp +b" buf))
  ;;                          (icollect [i v (ipairs diags)] )
  ;;                          )) {})
  (add-cmd :ToggleInlayHints
           #(let [{: enable : is_enabled} vim.lsp.inlay_hint]
              (enable (not (is_enabled))))
           {:desc "Simple toggle command for turning off and on inlay hints."}))

{}
