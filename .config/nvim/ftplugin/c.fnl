(do
  (set vim.o.tabstop 2)
  (let [{: text : add-language-snippets : ins} (require :utils.snippets)]
    (add-language-snippets :c
                           [[:__main
                             [(text "#include <stdio.h>"
                                    "int main(int argc, char *argv[]) {" "\t")
                              (ins 1 "// your code")
                              (text "" "\treturn 0;" "}")]]])))

{}
