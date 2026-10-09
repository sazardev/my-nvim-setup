-- ── Fábricas de acciones reutilizables para los menús ────────────────────────
local log = require "utils.log"
local project = require "utils.project"
local terminal = require "utils.terminal"

local M = {}

--- Acción que ejecuta un comando Ex
---@param name string
---@return fun()
function M.ex(name)
  return function()
    vim.cmd(name)
  end
end

--- Acción que corre `cmd` en la raíz del proyecto; avisa si falta `bin`
---@param bin string ejecutable requerido
---@param cmd string
---@param markers? string[]
---@return fun()
function M.run(bin, cmd, markers)
  return function()
    if vim.fn.executable(bin) ~= 1 then
      return log.warn(("`%s` is not installed"):format(bin))
    end
    terminal.run(cmd, project.root(markers or { ".git" }))
  end
end

--- Formatea el buffer con conform (con fallback a LSP)
function M.format()
  require("conform").format { lsp_format = "fallback" }
end

--- Aplica una code action de tipo `kind` (p. ej. "source.organizeImports")
---@param kind string
---@return fun()
function M.code_action(kind)
  return function()
    vim.lsp.buf.code_action { context = { only = { kind }, diagnostics = {} }, apply = true }
  end
end

return M
