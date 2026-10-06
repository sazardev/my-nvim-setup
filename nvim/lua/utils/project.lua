-- ── Helpers de proyecto / sistema de archivos ────────────────────────────────
local M = {}

--- Directorio del archivo del buffer actual
---@return string
function M.file_dir()
  return vim.fn.expand "%:p:h"
end

--- Raíz del proyecto según marcadores (o el directorio del archivo)
---@param markers string[]
---@return string
function M.root(markers)
  return vim.fs.root(0, markers) or M.file_dir()
end

--- ¿Existe `name` dentro de `dir`?
---@param dir string
---@param name string
---@return boolean
function M.has(dir, name)
  return vim.uv.fs_stat(dir .. "/" .. name) ~= nil
end

--- Lee un archivo completo; nil si no existe
---@param path string
---@return string?
function M.read(path)
  local f = io.open(path, "r")
  if not f then
    return nil
  end
  local content = f:read "*a"
  f:close()
  return content
end

return M
