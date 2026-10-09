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
    terminal.run(("go %s %s"):format(sub, mod_root and "." or vim.fn.shellescape(vim.fn.expand "%:t")), dir)
  end
end

local function in_root(cmd)
  return function()
    local dir, mod_root = paths()
    terminal.run(cmd, mod_root or dir)
  end
end

-- Comandos de go.nvim (no se carga en modo ligero)
local function go_cmd(cmd)
  return function()
    if vim.fn.exists(":" .. cmd:match "^%S+") ~= 2 then
      return log.warn "go.nvim is not loaded (light mode?)"
    end
    vim.cmd(cmd)
  end
end

return {
  { "a", "struct: add json tags", go_cmd "GoAddTag json" },
  { "A", "struct: add json tags + omitempty", go_cmd "GoAddTag json -add-options json=omitempty" },
  { "D", "struct: remove json tags", go_cmd "GoRmTag json" },
  { "s", "struct: fill literal", go_cmd "GoFillStruct" },
  { "e", "if err != nil (call)", go_cmd "GoIfErr" },
  { "T", "add test (func)", go_cmd "GoAddTest" },
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
        return log.warn "No go.mod in the project"
      end
      terminal.run("go mod tidy", mod_root)
    end,
  },
  { "x", "lint --fix", in_root "golangci-lint run --fix ./..." },
  { "m", "test", in_root "go test ./..." },
  { "R", "test -race", in_root "go test -race ./..." },
  { "c", "test coverage", in_root "go test -cover ./..." },
  -- go fix (modernizers del toolchain: any, rangeint, minmax, slices*, etc.)
  { "p", "fix preview (diff)", in_root "go fix -diff ./..." },
  { "i", "fix (apply modernizers)", in_root "go fix ./..." },
  { "g", "generate", in_root "go generate ./..." },
  { "u", "update deps + tidy", in_root "go get -u ./... && go mod tidy" },
}
