local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", {clear = true})
local metals_config = (require("metals")).bare_config()
metals_config.settings = {fallbackScalaVersion = "2.13.10", sbtScript = "/Users/js/.nix-profile/bin/sbt"}
local cb
local function _1_()
  return (require("metals")).initialize_or_attach(metals_config)
end
cb = _1_
return vim.api.nvim_create_autocmd("FileType", {pattern = {"scala", "sbt"}, callback = cb, group = nvim_metals_group})
