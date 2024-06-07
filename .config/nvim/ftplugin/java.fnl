; settings

(set vim.o.formatprg (table.concat [:google-java-format "-"] " "))
(set vim.bo.tabstop 4)
(set vim.wo.foldlevel 1)
(set vim.wo.foldnestmax 1)

;; conditionally use spotlessApply if it's available to the gradle project.
(let [nnoremap #(vim.api.nvim_buf_set_keymap 0 :n $1 $2
                                             {:noremap true :silent true})
      map-spotless #(nnoremap :g=
                              ":!cd $(git rev-parse --show-toplevel); gradle spotlessApply<enter>")
      map-lsp #(nnoremap :g= ":lua vim.lsp.buf.format{async = false}<enter>")
      set-map #(match $2
                 0 (map-spotless)
                 _ (map-lsp))]
  (vim.fn.jobstart "cd $(git rev-parse --show-toplevel) && gradle spotlessDiagnose"
                   {:on_exit set-map}))

; lsp
(let [jdtls (require :jdtls)
      cmp_nvim_lsp (require :cmp_nvim_lsp)
      capabilities (. (cmp_nvim_lsp.default_capabilities (vim.lsp.protocol.make_client_capabilities)))
      extendedClientCapabilities (let [c jdtls.extendedClientCapabilities]
                                   (tset c :onCompletionItemSelectedCommand
                                         :editor.action.triggerParameterHints)
                                   c)
      ;; on_attach #(vim.lsp.inlay_hint $2 true)
      config {:cmd [:jdtlsw]
              : capabilities
              :init_options {: extendedClientCapabilities}
              :root_dir (let [find-result (-> (vim.fs.find [:.gradlew
                                                            :.git
                                                            :mvnw]
                                                           {:upward true})
                                              (. 1))]
                          (vim.fs.dirname find-result))
              :settings {:java {:signatureHelp {:enabled true}
                                :inlayHints {:parameterNames {:enabled :all}}
                                :format {:settings {:url "https://google.github.io/styleguide/intellij-java-google-style.xml"}}}}}]
  (jdtls.start_or_attach config))

; wip - get function name
; (fn get-function-name []
;   (let [util (require :nvim-treesitter.ts_utils)
;         rec (fn [node]
;               (if (= (node:type) :function_definition) node (rec node)))
;         current-node (util.get_node_at_cursor)])
;   (rec current-node))

; snippets
(let [ls (require :luasnip)
      s ls.snippet
      t ls.text_node
      i ls.insert_node
      println (let [phrase :.print
                    stmnt (t [:System.out.println])
                    t-start (t ["(\""])
                    ins (i 0)
                    t-end (t ["\");"])]
                (s phrase [stmnt t-start ins t-end]))
      class (let [phrase :.interface
                  stmnt (t ["public interface"])
                  interface-name (i 1 :interfaceName)
                  fn-start (t ["{"])
                  end-pt (i 0)
                  fn-end (t ["}"])]
              (s phrase [stmnt interface-name fn-start end-pt fn-end]))]
  (ls.cleanup)
  (ls.add_snippets :java [println class]))

{}
