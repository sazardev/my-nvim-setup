-- ── Ajustes del usuario (única fuente de verdad configurable) ────────────────
-- Todo lo "ajustable" vive aquí con su valor por defecto. Para cambiarlo sin
-- tocar el repo, crea `lua/local.lua` (ignorado por git) devolviendo una tabla
-- parcial, o define `vim.g.nvim_settings` antes de cargar la config:
--
--   -- lua/local.lua
--   return { theme = { name = "catppuccin" }, languages = { disabled = { "astro" } } }
local defaults = {
  theme = {
    -- Tema por defecto (el que vuelve al elegir "default" en <leader>S)
    name = "gruvbox",
    toggle = { "gruvbox", "gruvbox_light" },

    -- Tema heredado de la terminal (Alacritty): ver lua/appearance/
    terminal = {
      enabled = true,
      config = nil, -- ruta a alacritty.toml; nil = autodetección (Linux, Windows, WSL)
      min_contrast = 3.0, -- contraste mínimo de los colores de acento contra el fondo
      watch_ms = 1000, -- sondeo de la config de Alacritty para seguirla en vivo (0 = apagado)
    },
  },

  -- Modo ligero (equipos de poca RAM): sin LSP residente ni go.nvim.
  -- `force`: true/false fuerza el modo; nil = autodetección por RAM.
  -- La variable de entorno NVIM_LIGHT=1|0 tiene prioridad sobre esto.
  light = {
    force = nil,
    ram_threshold_gb = 2,
  },

  -- Lenguajes (ver lua/languages/): desactiva por nombre los que no uses.
  languages = {
    disabled = {},
  },

  format_on_save = {
    enabled = true,
    timeout_ms = 2000,
  },

  -- Clipboard por OSC 52 (WSL/SSH sin servidor gráfico): "auto" | true | false
  clipboard = {
    osc52 = "auto",
  },

  -- Terminal integrada (toggleterm): la usan los menús por lenguaje y lazydocker.
  -- position: "right" (panel lateral) | "bottom" | "float". Con menos de
  -- `narrow_columns` columnas el panel lateral pasa abajo (no aplasta el código).
  terminal = {
    position = "right",
    width = 0.38, -- fracción de las columnas (panel lateral)
    min_width = 50,
    height = 0.35, -- fracción de las líneas (panel inferior)
    min_height = 8,
    narrow_columns = 120,
    float_scale = 0.85, -- fracción de la pantalla en modo float
  },

  -- Linters que NO corren en InsertLeave (analizan todo el paquete: pesados)
  lint = {
    skip_insert_leave = { "go" },
  },

  -- vim.o.<clave> = valor
  options = {
    cmdheight = 0,
    showmode = false,
    showcmd = false,
    laststatus = 3,
    lazyredraw = true,
    synmaxcol = 200,
    updatetime = 350,
    more = false,
    pumblend = 0,
    winblend = 0,
    redrawtime = 1500,
    confirm = true,
    timeoutlen = 300,
    ttimeoutlen = 50,
    splitright = true,
    splitbelow = true,
    scrolloff = 5,
    sidescrolloff = 8,
    cursorline = true,
    cursorlineopt = "number",
    signcolumn = "yes:1",
    exrc = true, -- carga .nvim.lua por proyecto (protegido por :trust)
  },
}

local overrides = {}

local ok, localcfg = pcall(require, "local")
if ok and type(localcfg) == "table" then
  overrides = localcfg
end

return vim.tbl_deep_extend("force", defaults, overrides, vim.g.nvim_settings or {})
