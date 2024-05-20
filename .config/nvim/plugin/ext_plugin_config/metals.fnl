(local nvim_metals_group
       (vim.api.nvim_create_augroup :nvim-metals {:clear true}))

(local metals_config ((. (require :metals) :bare_config)))
(set metals_config.settings
     {:fallbackScalaVersion :3.1.3
      ;:showImplicitArguments true
      :sbtScript :sbt })

(set metals_config.capabilities
     ((. (require :cmp_nvim_lsp) :default_capabilities)))

; -- Example of settings
; metals_config.settings = {
;   showImplicitArguments = true,
;   excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
; }

(let [cb (fn []
           ((. (require :metals) :initialize_or_attach) metals_config))]
  (vim.api.nvim_create_autocmd :FileType
                               {:pattern [:scala :sbt]
                                :callback cb
                                :group nvim_metals_group}))
