-- ── Estado persistente de la apariencia ──────────────────────────────────────
-- Dos archivos, ambos fuera del repo (estado de máquina):
--   · elección  (stdpath "state"):  qué tema quiere el usuario.
--   · compilado (junto a la caché de base46): qué tema contiene REALMENTE la
--     caché de highlights y con qué firma de la terminal. Vive con la caché para
--     que nunca se desincronicen (si una se borra, la otra también).
local M = {}

---@param path string
---@return table
local function read_json(path)
  local f = io.open(path, "r")
  if not f then
    return {}
  end
  local ok, data = pcall(vim.json.decode, f:read "*a")
  f:close()
  return ok and type(data) == "table" and data or {}
end

---@param path string
---@param data table
local function write_json(path, data)
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  local f = io.open(path, "w")
  if f then
    f:write(vim.json.encode(data))
    f:close()
  end
end

local function choice_path()
  return vim.fn.stdpath "state" .. "/appearance.json"
end

local function compiled_path()
  return vim.g.base46_cache .. "appearance.json"
end

---@return { theme: string? }
function M.read_choice()
  return read_json(choice_path())
end

---@param theme string
function M.write_choice(theme)
  write_json(choice_path(), { theme = theme })
end

---@return { theme: string?, signature: string? }
function M.read_compiled()
  return read_json(compiled_path())
end

---@param data { theme: string, signature: string? }
function M.write_compiled(data)
  write_json(compiled_path(), data)
end

return M
