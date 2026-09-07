-- ── Detección de recursos: modo ligero vs completo ───────────────────────────
-- En equipos de poca RAM (Orange Pi 1-2GB, VMs recortadas) desactivamos todo lo
-- residente: LSP (gopls cuesta 150-500MB), go.nvim, golangci-lint.
-- Se mantiene lo barato: treesitter, conform (formatea al guardar con procesos
-- efímeros), nvim-lint.
local M = {}

local LIGHT_THRESHOLD = 2 * 1024 * 1024 * 1024 -- 2GB en bytes

local function total_ram()
  local ok, mem = pcall(vim.uv.get_total_memory)
  if ok and mem and mem > 0 then
    return mem
  end
  -- fallback Linux
  local f = io.open("/proc/meminfo", "r")
  if f then
    local line = f:read "*l"
    f:close()
    local kb = line and line:match "MemTotal:%s+(%d+)"
    if kb then
      return tonumber(kb) * 1024
    end
  end
  return 0
end

-- Overrides manuales (por si la detección falla o quieres forzar):
--   NVIM_LIGHT=1  → fuerza modo ligero
--   NVIM_LIGHT=0  → fuerza modo completo
--   vim.g.light_mode = true (en options.lua)
local env = vim.env.NVIM_LIGHT
if env == "1" then
  M.light = true
elseif env == "0" then
  M.light = false
elseif vim.g.light_mode ~= nil then
  M.light = vim.g.light_mode
else
  local ram = total_ram()
  M.light = ram > 0 and ram <= LIGHT_THRESHOLD
end

return M
