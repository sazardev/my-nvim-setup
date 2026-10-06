-- El formateo requiere prettier-plugin-astro en el proyecto (o global).
return {
  filetypes = { "astro" },
  treesitter = { "astro" },
  lsp = { "astro" },
  mason = { full = { "astro-language-server", "prettier" } },
  formatters = { astro = { "prettier" } },
}
