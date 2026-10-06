-- Servidores LSP: lista en lua/languages/, overrides en lua/servers/.
return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },
  config = function()
    require("servers").setup()
  end,
}
