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

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})
