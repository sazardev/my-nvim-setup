local prettier = { "prettier" }
local eslint = { "eslint_d" }

return {
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  treesitter = { "javascript", "typescript", "tsx" },
  lsp = { "vtsls", "eslint" },
  mason = { full = { "prettier", "eslint_d", "vtsls", "eslint-lsp" } },
  formatters = {
    javascript = prettier,
    typescript = prettier,
    javascriptreact = prettier,
    typescriptreact = prettier,
  },
  linters = {
    javascript = eslint,
    typescript = eslint,
    javascriptreact = eslint,
    typescriptreact = eslint,
  },
  menu = { name = "TypeScript / JavaScript", prefix = "t", maps = require "languages.actions.typescript" },
}
