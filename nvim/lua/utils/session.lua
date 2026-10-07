-- ── Sesiones (persistence.nvim): helpers para menús y dashboard ──────────────
local log = require "utils.log"

local M = {}

---@return table? persistence
local function persistence()
  local ok, p = pcall(require, "persistence")
  return ok and p or nil
end

--- Archivo de sesión de esta carpeta: el de la rama actual y, si no hay, el de
--- la rama principal (mismo orden que usa `persistence.load`).
---@return string?
local function current_file()
  local p = persistence()
  if not p then
    return nil
  end
  for _, file in ipairs { p.current(), p.current { branch = false } } do
    if vim.fn.filereadable(file) == 1 then
      return file
    end
  end
end

---@return boolean hay sesión guardada para esta carpeta
function M.exists()
  return current_file() ~= nil
end

function M.restore()
  if not M.exists() then
    return log.warn "No hay sesión guardada para esta carpeta"
  end
  persistence().load()
end

--- Elige una sesión de cualquier proyecto (cambia de carpeta y la restaura)
function M.pick()
  local p = persistence()
  if p then
    p.select()
  end
end

--- Restaura la última sesión guardada (de cualquier proyecto)
function M.last()
  local p = persistence()
  if not p or not p.last() then
    return log.warn "No hay sesiones guardadas"
  end
  p.load { last = true }
end

function M.save()
  local p = persistence()
  if p then
    p.save()
    log.info "Sesión guardada"
  end
end

--- Deja de guardar la sesión al salir (solo en esta ejecución de nvim)
function M.stop()
  local p = persistence()
  if p then
    p.stop()
    log.info "Esta sesión no se guardará al salir"
  end
end

--- Cierra las ventanas que no son de archivos (nvim-tree, aerial, trouble,
--- toggleterm, quickfix, ayuda...) para que no se guarden en la sesión.
function M.close_auxiliary()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local floating = vim.api.nvim_win_get_config(win).relative ~= ""
    if not floating and vim.bo[buf].buftype ~= "" and #vim.api.nvim_tabpage_list_wins(0) > 1 then
      pcall(vim.api.nvim_win_close, win, false)
    end
  end
end

return M
