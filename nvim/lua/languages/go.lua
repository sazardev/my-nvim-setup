return {
  filetypes = { "go", "gomod", "gowork" },
  treesitter = { "go", "gomod", "gosum", "gowork" },
  lsp = { "gopls" },
  mason = {
    always = { "goimports", "gofumpt" },
    full = { "gopls", "golangci-lint" },
  },
  formatters = { go = { "goimports", "gofumpt" } }, -- primero imports, luego formato estricto
  linters = { go = { "golangcilint" } },
  linters_light = { go = { "govet" } }, -- go vet es efímero; golangci-lint es pesado

  -- nvim-lint no trae "govet" de fábrica (solo "golangcilint"); go vet ya viene
  -- con el toolchain, cero instalación extra.
  setup_lint = function(lint)
    lint.linters.govet = {
      cmd = "go",
      args = { "vet", "./..." },
      stdin = false,
      ignore_exitcode = true,
      append_fname = false,
      stream = "stderr",
      parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", { source = "govet" }),
    }
  end,

  menu = { name = "Go", prefix = "g", maps = require "languages.actions.go" },
}
