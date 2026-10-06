-- ── Carga de la caché de base46 (tema de NvChad) ─────────────────────────────
local M = {}

function M.load()
  -- Si el tema activo es el de la terminal y Alacritty cambió, recompila antes de leer la caché
  require("appearance").sync()

  for _, name in ipairs { "defaults", "statusline" } do
    dofile(vim.g.base46_cache .. name)
  end
end

return M
