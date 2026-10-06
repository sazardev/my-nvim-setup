-- ── Acciones de Python ───────────────────────────────────────────────────────
local actions = require "utils.actions"
local log = require "utils.log"
local project = require "utils.project"
local terminal = require "utils.terminal"

local MARKERS = { "pyproject.toml", "pytest.ini", "setup.cfg", ".git" }

--- `uv` solo si está instalado y el proyecto tiene pyproject.toml
local function use_uv()
  return vim.fn.executable "uv" == 1 and vim.fs.root(0, { "pyproject.toml" }) ~= nil
end

local function current_file()
  return vim.fn.shellescape(vim.fn.expand "%:p")
end

return {
  {
    "r",
    "run archivo",
    function()
      terminal.float((use_uv() and "uv run " or "python3 ") .. current_file(), project.root(MARKERS))
    end,
  },
  {
    "i",
    "REPL con el archivo",
    function()
      terminal.float("python3 -i " .. current_file(), project.file_dir())
    end,
  },
  {
    "m",
    "pytest",
    function()
      terminal.float(use_uv() and "uv run pytest" or "python3 -m pytest", project.root(MARKERS))
    end,
  },
  {
    "t",
    "pytest (archivo)",
    function()
      terminal.float("python3 -m pytest " .. current_file(), project.root(MARKERS))
    end,
  },
  { "v", "ruff check", actions.run("ruff", "ruff check .", MARKERS) },
  { "x", "ruff check --fix", actions.run("ruff", "ruff check --fix .", MARKERS) },
  {
    "f",
    "ruff format (archivo)",
    function()
      if vim.fn.executable "ruff" ~= 1 then
        return log.warn "`ruff` no está instalado"
      end
      vim.cmd "silent write"
      terminal.float("ruff format " .. current_file(), project.file_dir())
    end,
  },
}
