-- ── Carga de la caché de base46 (tema de NvChad) ─────────────────────────────
local M = {}

function M.load()
  for _, name in ipairs { "defaults", "statusline" } do
    dofile(vim.g.base46_cache .. name)
  end
end

return M
