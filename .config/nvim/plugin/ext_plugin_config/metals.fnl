(let [nvim_metals_group (vim.api.nvim_create_augroup :nvim-metals {:clear true})
      {: bare_config : initialize_or_attach} (require :metals)
      config (bare_config)
      {: default_capabilities} (require :cmp_nvim_lsp)
      capabilities (default_capabilities)]
  (do
    (set config.settings {:fallbackScalaVersion :3.1.3
                          :sbtScript :sbt
                          :autoImportBuild :all
                          :metalsBinaryPath vim.g.METALS_PATH})
    (set config.capabilities capabilities)
    (vim.api.nvim_create_autocmd :FileType
                                 {:pattern [:scala :sbt]
                                  :callback #(initialize_or_attach config)
                                  :group nvim_metals_group})))

{}
