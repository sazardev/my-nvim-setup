-- El LSP (dartls) lo gestiona flutter-tools.nvim, no vim.lsp.enable.
return {
  filetypes = { "dart" },
  treesitter = { "dart" },
  formatters = { dart = { "dart_format" } },
  menu = { name = "Dart / Flutter", prefix = "d", maps = require "languages.actions.dart" },
}
