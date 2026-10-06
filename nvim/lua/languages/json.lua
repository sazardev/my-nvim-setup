return {
  filetypes = { "json" },
  treesitter = { "json" },
  lsp = { "jsonls" }, -- schemas vía SchemaStore (ver servers/jsonls.lua)
  mason = { full = { "prettier", "json-lsp", "jsonlint" } },
  formatters = { json = { "prettier" } },
  linters = { json = { "jsonlint" } },
}
