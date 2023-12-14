; settings
(set vim.o.formatprg (table.concat [:google-java-format "-"] " "))
(set vim.bo.tabstop 4)
(set vim.wo.foldlevel 1)
(set vim.wo.foldnestmax 1)

; lsp
(let [jdtls (require :jdtls)
      c1 (. ((. (require :cmp_nvim_lsp) :default_capabilities) (vim.lsp.protocol.make_client_capabilities)))
      capabilities (let [c jdtls.extendedClientCapabilities]
                     (tset c :onCompletionItemSelectedCommand
                           :editor.action.triggerParameterHints)
                     c)
      on-attach (fn [_ bufnr] (vim.lsp.buf.inlay_hint bufnr true)
                  (vim.lsp.inlay_hint bufnr true))
      config {:on_attach on-attach
              :cmd [:jdtlsw]
              :capabilities c1
              :init_options {:extendedClientCapabilities capabilities}
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
              (s phrase stmnt interface-name fn-start end-pt fn-end))]
  (ls.cleanup)
  (ls.add_snippets :java [println class]))

; relic
(vim.api.nvim_exec "command! SA !cd $(git rev-parse --show-toplevel); gradle spotlessApply %"
                   false)

{}
