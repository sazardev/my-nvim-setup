-- ── Lectura de la config de Alacritty ────────────────────────────────────────
-- Localiza alacritty.toml, resuelve sus `import` con las reglas de Alacritty
-- (los imports se aplican en orden; el archivo que importa pisa a sus imports)
-- y devuelve la paleta de colores resultante.
local toml = require "appearance.toml"

local M = {}

local MAX_IMPORT_DEPTH = 5

local NAMES = { "normal", "bright" }
local ANSI = { "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white" }

--- Colores por defecto de Alacritty cuando la config no define `[colors]`
local DEFAULTS = {
  background = "#181818",
  foreground = "#d8d8d8",
  normal = { "#181818", "#ac4242", "#90a959", "#f4bf75", "#6a9fb5", "#aa759f", "#75b5aa", "#d8d8d8" },
  bright = { "#6b6b6b", "#c55555", "#aac474", "#feca88", "#82b8c8", "#c28cb8", "#93d3c3", "#f8f8f8" },
}

--- Marca de modificación de un archivo (mtime + tamaño); "" si no existe
---@param path string
---@return string
local function stamp(path)
  local stat = vim.uv.fs_stat(path)
  return stat and ("%d.%d:%d"):format(stat.mtime.sec, stat.mtime.nsec, stat.size) or ""
end

---@param path string
---@return string
local function expand(path)
  return vim.fs.normalize(path)
end

--- Candidatas en orden de prioridad: override del usuario, Linux/macOS, Windows y
--- (en WSL) el AppData de Windows más recientemente modificado.
---@return string[]
local function candidates()
  local list = {}
  local override = require("core.settings").theme.terminal.config
  if override then
    table.insert(list, expand(override))
  end

  local xdg = vim.env.XDG_CONFIG_HOME or "~/.config"
  vim.list_extend(list, { expand(xdg .. "/alacritty/alacritty.toml"), expand "~/.alacritty.toml" })
  if vim.env.APPDATA then
    table.insert(list, expand(vim.env.APPDATA .. "/alacritty/alacritty.toml"))
  end

  -- WSL: Alacritty corre en Windows y su config vive en /mnt/<disco>/Users/*/AppData
  local wsl = vim.fn.glob("/mnt/*/Users/*/AppData/Roaming/alacritty/alacritty.toml", false, true)
  table.sort(wsl, function(a, b)
    local sa, sb = vim.uv.fs_stat(a), vim.uv.fs_stat(b)
    return (sa and sa.mtime.sec or 0) > (sb and sb.mtime.sec or 0)
  end)
  return vim.list_extend(list, wsl)
end

---@return string?
function M.find_config()
  for _, path in ipairs(candidates()) do
    if vim.uv.fs_stat(path) then
      return path
    end
  end
end

---@param value any
---@return string? "#rrggbb"
local function normalize(value)
  if type(value) ~= "string" then
    return nil
  end
  local hex = value:match "^#(%x%x%x%x%x%x)$" or value:match "^0x(%x%x%x%x%x%x)$"
  return hex and "#" .. hex:lower() or nil
end

---@param a table
---@param b table
---@return table b mezclado sobre a (b gana)
local function merge(a, b)
  return vim.tbl_deep_extend("force", a, b)
end

--- Lee un archivo y todos sus imports (recursivo). Devuelve la tabla fusionada y
--- registra cada archivo visitado y cuál definió el fondo.
---@param path string
---@param ctx { files: table[], theme_file: string? }
---@param depth integer
---@return table
local function load_file(path, ctx, depth)
  -- La marca se toma ANTES de leer: si el archivo cambia entre ambas cosas, la
  -- marca queda más vieja que el contenido y el sondeo lo detecta como obsoleto
  -- (al revés se perdería la actualización).
  local file_stamp = stamp(path)
  local f = io.open(path, "r")
  if not f then
    return {}
  end
  local text = f:read "*a"
  f:close()

  table.insert(ctx.files, { path = path, stamp = file_stamp })

  local own = toml.parse(text)
  local imports = (own.general and own.general.import) or own.import or {}

  local result = {}
  if depth < MAX_IMPORT_DEPTH then
    for _, rel in ipairs(type(imports) == "table" and imports or {}) do
      local target = expand(rel:sub(1, 1) == "~" and rel or (vim.fs.dirname(path) .. "/" .. rel))
      result = merge(result, load_file(target, ctx, depth + 1))
    end
  end

  if own.colors and own.colors.primary and own.colors.primary.background then
    ctx.theme_file = path
  end
  return merge(result, own)
end

---@param colors table sección [colors] fusionada
---@return table palette
local function build_palette(colors)
  local primary = colors.primary or {}
  local palette = {
    background = normalize(primary.background) or DEFAULTS.background,
    foreground = normalize(primary.foreground) or DEFAULTS.foreground,
    selection = normalize((colors.selection or {}).background),
    cursor = normalize((colors.cursor or {}).cursor),
    ansi = {}, -- ansi[1..16] = black..white, bright black..bright white
  }
  for set_index, set in ipairs(NAMES) do
    for i, name in ipairs(ANSI) do
      palette.ansi[(set_index - 1) * 8 + i] = normalize((colors[set] or {})[name]) or DEFAULTS[set][i]
    end
  end
  return palette
end

---@type table?
local cache

--- Carga y cachea la paleta de Alacritty
---@return { palette: table, config: string, theme_file: string?, signature: string }?, string? err
function M.load()
  if cache then
    return cache
  end
  local config = M.find_config()
  if not config then
    return nil, "Alacritty config not found (see theme.terminal.config in core/settings.lua)"
  end
  local ctx = { files = {} }
  local merged = load_file(config, ctx, 0)
  cache = {
    palette = build_palette(merged.colors or {}),
    config = config,
    theme_file = ctx.theme_file,
    files = ctx.files,
    signature = table.concat(
      vim.tbl_map(function(f)
        return f.path .. ":" .. f.stamp
      end, ctx.files),
      "|"
    ),
  }
  return cache
end

--- Firma de los archivos que definen la paleta (cambia si se edita cualquiera)
---@return string?
function M.signature()
  M.reset()
  local loaded = M.load()
  return loaded and loaded.signature or nil
end

--- ¿Cambió algún archivo de la config desde la última lectura? Solo hace `stat`
--- (sin releer ni parsear), así que es apto para sondeo periódico.
---@return boolean
function M.is_stale()
  if not cache then
    return false
  end
  for _, file in ipairs(cache.files) do
    if stamp(file.path) ~= file.stamp then
      return true
    end
  end
  return false
end

--- Descarta la caché (releer en el próximo load)
function M.reset()
  cache = nil
end

return M
