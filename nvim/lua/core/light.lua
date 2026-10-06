-- ── Modo ligero: detección de recursos ───────────────────────────────────────
-- En equipos de poca RAM (Orange Pi 1-2GB, VMs recortadas) se desactiva todo lo
-- residente: LSP (gopls cuesta 150-500MB), go.nvim, golangci-lint. Se mantiene
-- lo barato: treesitter, conform (formatters efímeros) y nvim-lint.
--
-- Prioridad: NVIM_LIGHT=1|0  >  settings.light.force  >  vim.g.light_mode  >  RAM
local settings = require "core.settings"

local M = {}

---@return integer bytes de RAM total (0 si no se pudo leer)
local function total_ram()
  local ok, mem = pcall(vim.uv.get_total_memory)
  if ok and mem and mem > 0 then
    return mem
  end
  local f = io.open("/proc/meminfo", "r")
  if not f then
    return 0
  end
  local line = f:read "*l"
  f:close()
  local kb = line and line:match "MemTotal:%s+(%d+)"
  return kb and tonumber(kb) * 1024 or 0
end

---@return boolean
local function detect()
  local env = vim.env.NVIM_LIGHT
  if env == "1" then
    return true
  elseif env == "0" then
    return false
  end
  if settings.light.force ~= nil then
    return settings.light.force
  end
  if vim.g.light_mode ~= nil then
    return vim.g.light_mode
  end
  local ram = total_ram()
  return ram > 0 and ram <= settings.light.ram_threshold_gb * 1024 * 1024 * 1024
end

M.enabled = detect()

return M
