return {
  filetypes = { "html" },
  treesitter = { "html" },
  lsp = { "html", "emmet_ls" },
  mason = { full = { "prettier", "html-lsp", "emmet-ls" } },
  formatters = { html = { "prettier" } },
}
