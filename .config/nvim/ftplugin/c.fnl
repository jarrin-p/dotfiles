(do
  (set vim.o.tabstop 2)
  (vim.api.nvim_create_autocmd :LspAttach
                               {:callback (fn [args]
                                            (let [client (vim.lsp.get_client_by_id args.data.client_id)]
                                              (set client.server_capabilities.semanticTokensProvider
                                                   nil)))})
  (let [{: text : add-language-snippets : ins} (require :utils.snippets)]
    (add-language-snippets :c
                           [[:__main
                             [(text "#include <stdio.h>"
                                    "int main(int argc, char *argv[]) {" "\t")
                              (ins 1 "// your code")
                              (text "" "\treturn 0;" "}")]]])))

{}
