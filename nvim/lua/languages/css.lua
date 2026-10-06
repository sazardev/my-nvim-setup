return {
  filetypes = { "css", "scss", "less" },
  treesitter = { "css" },
  lsp = { "cssls" },
  mason = { full = { "prettier", "css-lsp" } },
  formatters = { css = { "prettier" } },
  menu = { name = "CSS", prefix = "s", maps = require "languages.actions.css" },
}
