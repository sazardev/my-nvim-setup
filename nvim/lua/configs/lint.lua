local lint = require "lint"

-- ── YarnSpinner linter via ysc CLI ────────────────────────────────────────────
-- Requiere: dotnet tool install -g yarn-spinner
-- Formato de error: path(lnum,col): severity CODE: message
lint.linters.ysc = {
  name = "ysc",
  cmd = "ysc",
  stdin = false,
  args = { "compile", "--stdout" },
  stream = "stderr",
  ignore_exitcode = true,
  parser = require("lint.parser").from_pattern(
    "[^%(]+%((%d+),(%d+)%): (%a+) %w+: (.+)",
    { "lnum", "col", "severity", "message" },
    {
      ["error"]   = vim.diagnostic.severity.ERROR,
      ["warning"] = vim.diagnostic.severity.WARN,
    }
  ),
}

lint.linters_by_ft = {
  go              = { "golangcilint" },
  javascript      = { "eslint_d" },
  typescript      = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  markdown        = { "markdownlint" },
  json            = { "jsonlint" },
  yarnspinner     = { "ysc" },   -- requiere: dotnet tool install -g yarn-spinner
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
  callback = function()
    lint.try_lint()
  end,
})

-- ── Modo ligero: go vet (efímero) en vez de golangci-lint residente ──────────
-- nvim-lint no trae "govet" de fábrica (solo "golangcilint"), así que lo
-- definimos: go vet ya viene con el toolchain, cero instalación extra.
lint.linters.govet = {
  cmd = "go",
  args = { "vet", "./..." },
  stdin = false,
  ignore_exitcode = true,
  append_fname = false,
  stream = "stderr",
  parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
    source = "govet",
  }),
}

if require("configs.resources").light then
  lint.linters_by_ft.go = { "govet" }
end

-- InsertLeave: solo linters livianos. golangci-lint analiza todo el paquete
-- y correrlo en cada salida de insert satura CPU en máquinas de bajos recursos.
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if vim.bo.filetype ~= "go" then
      lint.try_lint()
    end
  end,
})
