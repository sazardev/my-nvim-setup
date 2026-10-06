-- ── Apariencia: persistencia y sincronización con la terminal ────────────────
local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup("Appearance", { clear = true })

  -- Cualquier cambio de tema (también desde el selector de NvChad) se recuerda
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "NvThemeReload",
    callback = function()
      require("appearance").persist()
    end,
  })

  -- Seguimiento en vivo de Alacritty (solo si el tema activo es el terminal)
  vim.schedule(function()
    require("appearance").watch()
  end)
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      require("appearance.watcher").stop()
    end,
  })

  -- Al volver a Neovim: si cambiaste el tema de Alacritty, lo sigue
  vim.api.nvim_create_autocmd("FocusGained", {
    group = group,
    callback = function()
      vim.schedule(function()
        local appearance = require "appearance"
        if appearance.current() == appearance.TERMINAL and appearance.sync() then
          require("utils.log").info "Tema terminal actualizado"
        end
      end)
    end,
  })
end

return M
