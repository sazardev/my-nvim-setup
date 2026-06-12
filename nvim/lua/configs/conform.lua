local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    -- Go (en cadena: primero imports, luego formato estricto)
    go = { "goimports", "gofumpt" },

    -- Frontend
    javascript      = { "prettier" },
    typescript      = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    css             = { "prettier" },
    html            = { "prettier" },
    json            = { "prettier" },
    yaml            = { "prettier" },
    -- Markdown: prettier formatea, markdownlint-cli2 corrige reglas
    markdown        = { "markdownlint-cli2", "prettier" },
    toml            = { "prettier" },
    -- Dart
    dart            = { "dart_format" },
    -- Astro (requiere prettier-plugin-astro en node_modules del proyecto)
    astro           = { "prettier" },
    -- Prisma (schemas multitenancy)
    prisma          = { "prisma" },
  },

  format_on_save = {
    timeout_ms = 2000,
    lsp_fallback = true,
  },
}

return options
