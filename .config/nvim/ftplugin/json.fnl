(let [{: setup-lsp} (require :utils.lsp-util)
      {: load-once} (require :utils.load-once)]
  (do
    (load-once :json
               #(setup-lsp :jsonls
                           {:cmd [:vscode-json-language-server :--stdio]}))
    (set vim.bo.formatprg :jq)))

{}
