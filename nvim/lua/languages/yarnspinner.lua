-- YarnSpinner (diálogos). ftdetect/ y syntax/ definen el filetype y el resaltado.
-- El linter `ysc` es opcional: solo se activa si está instalado
-- (dotnet tool install -g yarn-spinner; requiere dotnet).
local has_ysc = vim.fn.executable "ysc" == 1

return {
  filetypes = { "yarnspinner" },
  linters = has_ysc and { yarnspinner = { "ysc" } } or nil,

  -- Formato de error: path(lnum,col): severity CODE: message
  setup_lint = function(lint)
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
          ["error"] = vim.diagnostic.severity.ERROR,
          ["warning"] = vim.diagnostic.severity.WARN,
        }
      ),
    }
  end,
}
