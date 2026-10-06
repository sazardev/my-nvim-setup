-- ── Orquestador: orden de carga de la configuración base ─────────────────────
-- Cada responsabilidad vive en su módulo; aquí solo se decide el orden.
local M = {}

function M.setup()
  require("core.theme").load()
  require("core.options").setup()
  require("core.clipboard").setup()
  require("core.autocmds").setup()

  -- NvChad carga los keymaps con vim.schedule: se hace igual para que los
  -- mapeos de usuario pisen a los suyos.
  vim.schedule(function()
    require("core.keymaps").setup()
  end)
end

return M
