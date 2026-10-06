-- Sin formatter en conform: lo formatea prismals vía LSP (lsp_format = "fallback").
return {
  filetypes = { "prisma" },
  treesitter = { "prisma" },
  lsp = { "prismals" },
  mason = { full = { "prisma-language-server" } },
}
