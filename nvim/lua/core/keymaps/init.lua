-- ── Keymaps: orden importa (primero NvChad, luego limpieza, luego los nuestros) ─
local M = {}

function M.setup()
  require "nvchad.mappings"
  require("core.keymaps.cleanup").setup()
  require("core.keymaps.general").setup()
  require("menus").setup()
end

return M
