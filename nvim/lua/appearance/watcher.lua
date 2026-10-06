-- ── Seguimiento en vivo de la config de la terminal ──────────────────────────
-- Sondea (stat) los archivos de la config de Alacritty cada `watch_ms`. Se usa
-- sondeo y no inotify porque en WSL la config vive en Windows (/mnt/c) y esos
-- cambios no generan eventos. Solo corre mientras el tema activo es el terminal.
local alacritty = require "appearance.alacritty"
local settings = require "core.settings"

local M = {}

---@type uv.uv_timer_t?
local timer

---@return boolean
function M.active()
  return timer ~= nil
end

function M.stop()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

--- Arranca el sondeo; `on_change` se llama (en el hilo principal) al detectar cambios
---@param on_change fun()
function M.start(on_change)
  local interval = settings.theme.terminal.watch_ms
  if timer or not interval or interval <= 0 then
    return
  end
  timer = vim.uv.new_timer()
  timer:start(
    interval,
    interval,
    vim.schedule_wrap(function()
      if alacritty.is_stale() then
        on_change()
      end
    end)
  )
end

return M
