-- ── Apariencia: tema por defecto vs. tema heredado de la terminal ────────────
-- "default" = settings.theme.name (gruvbox). "terminal" = paleta de Alacritty
-- convertida a tema de base46 (ver terminal_theme.lua). Cualquier tema elegido
-- (también desde el selector de NvChad) se recuerda entre sesiones.
local alacritty = require "appearance.alacritty"
local log = require "utils.log"
local settings = require "core.settings"
local state = require "appearance.state"
local watcher = require "appearance.watcher"

local M = {}

M.TERMINAL = "terminal"

local function terminal_enabled()
  return settings.theme.terminal.enabled
end

---@return string
function M.default()
  return settings.theme.name
end

---@return string tema activo ahora
function M.current()
  return require("nvconfig").base46.theme
end

--- Tema con el que arranca Neovim: el último elegido, o el default si el tema
--- terminal ya no está disponible (sin config de Alacritty, desactivado...).
---@return string
function M.initial()
  local saved = state.read_choice().theme
  if saved == M.TERMINAL then
    return (terminal_enabled() and alacritty.load()) and M.TERMINAL or M.default()
  end
  return saved or M.default()
end

--- Sigue la config de Alacritty en vivo, pero solo mientras el tema activo sea el
--- terminal (con el default no hay ningún sondeo corriendo).
function M.watch()
  if M.current() ~= M.TERMINAL or not terminal_enabled() then
    return watcher.stop()
  end
  watcher.start(function()
    if M.sync() then
      log.info "Terminal theme updated"
    end
  end)
end

--- Recuerda el tema actual: la elección del usuario y lo que quedó compilado.
--- La firma es la de la lectura CACHEADA (la que usó la compilación), nunca una
--- relectura: si el archivo cambió durante la compilación, la firma guardada
--- queda vieja y el sondeo recompila (con una relectura se perdería ese cambio).
function M.persist()
  local name = M.current()
  local loaded = name == M.TERMINAL and alacritty.load() or nil
  state.write_choice(name)
  state.write_compiled { theme = name, signature = loaded and loaded.signature or nil }
  M.watch()
end

--- Aplica un tema: recompila los highlights de base46 en caliente
---@param name string
---@return boolean ok
function M.use(name)
  if name == M.TERMINAL then
    alacritty.reset()
    local loaded, err = alacritty.load()
    if not terminal_enabled() then
      log.warn "Terminal theme is disabled (settings.theme.terminal.enabled)"
      return false
    elseif not loaded then
      log.warn(err or "Could not read the terminal palette")
      return false
    end
  end

  package.loaded["themes.terminal"] = nil -- releer la paleta
  require("nvconfig").base46.theme = name
  require("base46").load_all_highlights()
  M.persist()
  return true
end

--- Alterna entre el tema por defecto y el heredado de la terminal
function M.toggle()
  local target = M.current() == M.TERMINAL and M.default() or M.TERMINAL
  if M.use(target) then
    log.info("Theme: " .. target)
  end
end

--- Garantiza que la caché de highlights corresponde al tema deseado (y, si es el
--- terminal, a la config actual de Alacritty); si no, recompila. Barato: solo
--- compara el marcador de la caché con la firma (mtime + tamaño) de los archivos.
---@return boolean changed
function M.sync()
  local desired = M.initial()
  local compiled = state.read_compiled()
  local signature = desired == M.TERMINAL and alacritty.signature() or nil
  if compiled.theme == desired and compiled.signature == signature then
    return false
  end
  return M.use(desired)
end

--- Origen del tema actual y estado del seguimiento en vivo, en una sola línea
--- (varias líneas disparan "Press ENTER" y se tragan las teclas siguientes)
---@return string
function M.info()
  local name = M.current()
  local loaded = name == M.TERMINAL and alacritty.load() or nil
  if loaded then
    local p = loaded.palette
    local live = watcher.active() and ("live every %d ms"):format(settings.theme.terminal.watch_ms) or "NOT watching"
    return ("Theme: terminal · %s · background %s · %d watched files · %s"):format(
      vim.fs.basename(loaded.theme_file or loaded.config),
      p.background,
      #loaded.files,
      live
    )
  end
  local detected = alacritty.find_config() and "Alacritty detected" or "no Alacritty config"
  return ("Theme: %s · %s"):format(name, detected)
end

return M
