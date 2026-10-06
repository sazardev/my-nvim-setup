-- ── Opciones de Neovim ───────────────────────────────────────────────────────
-- Los valores viven en core/settings.lua (`options`); aquí solo se aplican.
local settings = require "core.settings"

local M = {}

function M.setup()
  require "nvchad.options"

  for name, value in pairs(settings.options) do
    vim.o[name] = value
  end

  vim.opt.shortmess:append "c" -- silencia mensajes de completado

  -- Flotantes limpios (sin bordes chillones)
  vim.o.winhighlight = "NormalFloat:Normal,FloatBorder:Comment,FloatTitle:Comment"
end

return M
