-- ── Terminal integrada (toggleterm) ──────────────────────────────────────────
-- Posición y tamaño salen de settings.terminal y se recalculan en cada apertura
-- y al redimensionar la ventana (responsivo).
local settings = require "core.settings"

local M = {}

--- Dirección de toggleterm según el ancho actual de la pantalla
---@return "vertical"|"horizontal"|"float"
function M.direction()
  local cfg = settings.terminal
  if cfg.position == "float" then
    return "float"
  end
  if cfg.position == "bottom" or vim.o.columns < cfg.narrow_columns then
    return "horizontal"
  end
  return "vertical"
end

--- Tamaño (columnas o líneas) para un terminal de toggleterm
---@param term { direction: string }
---@return number
function M.size(term)
  local cfg = settings.terminal
  if term.direction == "vertical" then
    return math.max(cfg.min_width, math.floor(vim.o.columns * cfg.width))
  end
  return math.max(cfg.min_height, math.floor(vim.o.lines * cfg.height))
end

--- Ajusta los terminales abiertos tras un cambio de tamaño de la ventana
function M.refresh()
  for _, term in pairs(require("toggleterm.terminal").get_all()) do
    if term:is_open() and term:is_split() then
      -- toggleterm redimensiona la ventana actual: hay que hacerlo desde la del terminal
      vim.api.nvim_win_call(term.window, function()
        term:resize(M.size(term))
      end)
    end
  end
end

--- Ejecuta `cmd` en la terminal integrada con cwd `dir`
---@param cmd string
---@param dir string
function M.run(cmd, dir)
  local direction = M.direction()
  -- un terminal cerrado conserva su dirección anterior: la actualizamos
  for _, term in pairs(require("toggleterm.terminal").get_all()) do
    if not term:is_open() then
      term.direction = direction
    end
  end
  vim.cmd(("TermExec cmd=%s dir=%s direction=%s"):format(vim.fn.shellescape(cmd), vim.fn.shellescape(dir), direction))
end

return M
