-- ── Clipboard por OSC 52 ─────────────────────────────────────────────────────
-- Sin servidor gráfico (WSL, SSH) wl-copy/xclip no sirven; OSC 52 copia vía la
-- terminal (herdr lo reenvía a Alacritty). Pegar usa el registro sin nombre
-- porque Alacritty no responde a consultas OSC 52 (el pegado del sistema es
-- Ctrl+Shift+V en la terminal).
local settings = require "core.settings"

local M = {}

local function wanted()
  local mode = settings.clipboard.osc52
  if mode == "auto" then
    return vim.env.DISPLAY == nil and vim.env.WAYLAND_DISPLAY == nil
  end
  return mode == true
end

local function paste()
  return { vim.fn.split(vim.fn.getreg "", "\n"), vim.fn.getregtype "" }
end

function M.setup()
  if not wanted() then
    return
  end
  local osc52 = require "vim.ui.clipboard.osc52"
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy "+", ["*"] = osc52.copy "*" },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end

return M
