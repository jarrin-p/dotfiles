vim.o.formatprg = table.concat({"google-java-format", "-"}, " ")
vim.o.makeprg = "tmux send-keys -t {marked} escape 'Sgradle test' enter"
vim.bo.tabstop = 4
vim.wo.foldlevel = 1
vim.wo.foldnestmax = 1
do
  local jdtls = require("jdtls")
  local capabilities
  do
    local c = jdtls.extendedClientCapabilities
    c["onCompletionItemSelectedCommand"] = "editor.action.triggerParameterHints"
    capabilities = c
  end
  local on_attach
  local function _1_(_, bufnr)
    vim.lsp.buf.inlay_hint(bufnr, true)
    return vim.lsp.inlay_hint(bufnr, true)
  end
  on_attach = _1_
  local config
  local _2_
  do
    local find_result = (vim.fs.find({".gradlew", ".git", "mvnw"}, {upward = true}))[1]
    _2_ = vim.fs.dirname(find_result)
  end
  config = {on_attach = on_attach, cmd = {"jdtlsw"}, init_options = {extendedClientCapabilities = capabilities}, root_dir = _2_, settings = {java = {signatureHelp = {enabled = true}, inlayHints = {parameterNames = {enabled = "all"}}, format = {settings = {url = "https://google.github.io/styleguide/intellij-java-google-style.xml"}}}}}
  jdtls.start_or_attach(config)
end
do
  local ls = require("luasnip")
  local s = ls.snippet
  local t = ls.text_node
  local i = ls.insert_node
  local println
  do
    local phrase = "_print"
    local stmnt = t({"System.out.println"})
    local t_start = t({"(\""})
    local ins = i(0)
    local t_end = t({"\");"})
    println = s(phrase, {stmnt, t_start, ins, t_end})
  end
  local class
  do
    local phrase = "_interface"
    local stmnt = t({"public interface"})
    local interface_name = i(1, "interfaceName")
    local fn_start = t({"{"})
    local end_pt = i(0)
    local fn_end = t({"}"})
    class = s(phrase, stmnt, interface_name, fn_start, end_pt, fn_end)
  end
  ls.add_snippets({println, class})
end
do local _ = {} end
return vim.api.nvim_exec("command! SA !cd $(git rev-parse --show-toplevel); gradle spotlessApply %", false)
