(let [{: load-once} (require :utils.load-once)
      {: setup-lsp} (require :utils.lsp-util)]
  (do
    (load-once :rust #(setup-lsp :rust_analyzer {}))
    (set vim.bo.formatprg ":rustfmt \"%\"")))

{}
