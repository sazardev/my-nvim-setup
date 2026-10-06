return {
  filetypes = { "markdown" },
  treesitter = { "markdown" },
  mason = { full = { "markdownlint-cli2", "markdownlint", "prettier" } },
  -- markdownlint-cli2 corrige reglas; prettier formatea
  formatters = { markdown = { "markdownlint-cli2", "prettier" } },
  linters = { markdown = { "markdownlint" } },
  menu = { name = "Markdown", prefix = "m", maps = require "languages.actions.markdown" },
}
