-- ── Acciones de Go ───────────────────────────────────────────────────────────
-- run/build corren sobre el DIRECTORIO del archivo (un paquete Go es por
-- carpeta): "." si cuelga de un go.mod, o el archivo suelto si no hay módulo.
-- vet/fix/test corren "./..." desde la raíz del módulo.
local actions = require "utils.actions"
local log = require "utils.log"
local project = require "utils.project"
local terminal = require "utils.terminal"

---@return string dir, string? mod_root
local function paths()
  local dir = project.file_dir()
  local gomod = vim.fs.find("go.mod", { path = dir, upward = true })[1]
  return dir, gomod and vim.fs.dirname(gomod)
end

local function target(sub)
  return function()
    local dir, mod_root = paths()
    terminal.float(("go %s %s"):format(sub, mod_root and "." or vim.fn.shellescape(vim.fn.expand "%:t")), dir)
  end
end

local function in_root(cmd)
  return function()
    local dir, mod_root = paths()
    terminal.float(cmd, mod_root or dir)
  end
end

return {
  { "r", "run", target "run" },
  { "b", "build", target "build" },
  {
    "v",
    "vet / lint",
    function()
      in_root(vim.fn.executable "golangci-lint" == 1 and "golangci-lint run ./..." or "go vet ./...")()
    end,
  },
  { "f", "format", actions.format },
  {
    "t",
    "mod tidy",
    function()
      local _, mod_root = paths()
      if not mod_root then
        return log.warn "No hay go.mod en el proyecto"
      end
      terminal.float("go mod tidy", mod_root)
    end,
  },
  { "x", "lint --fix", in_root "golangci-lint run --fix ./..." },
  { "m", "test", in_root "go test ./..." },
}
