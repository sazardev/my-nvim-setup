-- ── Helpers de Markdown (modo lectura, ortografía, checkboxes, conteo) ───────
local log = require "utils.log"

local M = {}

local READING_WIDTH = 80
-- opciones de ventana que cambia el modo lectura (se guardan para restaurarlas)
local READING_OPTS =
  { "wrap", "linebreak", "number", "relativenumber", "signcolumn", "cursorline", "colorcolumn", "statuscolumn" }

--- Margen izquierdo (en espacios) para centrar el texto en `READING_WIDTH` columnas
---@param win integer
---@return string
local function margin(win)
  return string.rep(" ", math.max(0, math.floor((vim.api.nvim_win_get_width(win) - READING_WIDTH) / 2)))
end

local function recenter()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.w[win].reading_saved then
      vim.wo[win].statuscolumn = margin(win)
    end
  end
end

--- Modo lectura (toggle, solo esta ventana): texto centrado a 80 columnas con
--- ajuste de línea, sin números ni signos ni diagnósticos; al salir todo vuelve.
function M.reading_mode()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  local saved = vim.w[win].reading_saved

  if saved then
    for _, name in ipairs(READING_OPTS) do
      vim.wo[win][name] = saved[name]
    end
    vim.diagnostic.enable(saved.diagnostics, { bufnr = buf })
    vim.w[win].reading_saved = nil
    return log.info "Modo lectura: desactivado"
  end

  saved = { diagnostics = vim.diagnostic.is_enabled { bufnr = buf } }
  for _, name in ipairs(READING_OPTS) do
    saved[name] = vim.wo[win][name]
  end
  vim.w[win].reading_saved = saved

  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].cursorline = false
  vim.wo[win].colorcolumn = ""
  vim.wo[win].statuscolumn = margin(win)
  vim.diagnostic.enable(false, { bufnr = buf })

  vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
    group = vim.api.nvim_create_augroup("ReadingMode", { clear = true }),
    callback = recenter,
  })
  log.info "Modo lectura: activado"
end

--- Corrector ortográfico (es + en) en este buffer/ventana
function M.toggle_spell()
  local on = not vim.wo.spell
  vim.wo.spell = on
  if on then
    vim.bo.spelllang = "es,en"
  end
  log.info("Ortografía: " .. (on and "activada (es, en)" or "desactivada"))
end

--- Palabras del buffer (o de la selección) y tiempo de lectura a ~200 ppm
function M.word_count()
  local wc = vim.fn.wordcount()
  local words = wc.visual_words or wc.words
  log.info(("%d palabras · ~%d min de lectura"):format(words, math.max(1, math.ceil(words / 200))))
end

--- Marca/desmarca el checkbox de la línea; si no es una tarea, la convierte en una
--- (`- [ ] `), conservando viñeta (`-*+` o `1.`) e indentación.
function M.toggle_checkbox()
  local line = vim.api.nvim_get_current_line()

  for _, bullet in ipairs { "[-*+]", "%d+[.)]" } do
    local indent, b, mark, rest = line:match("^(%s*)(" .. bullet .. ")%s+%[([ xX])%]%s*(.*)$")
    if indent then
      return vim.api.nvim_set_current_line(("%s%s [%s] %s"):format(indent, b, mark == " " and "x" or " ", rest))
    end
    indent, b, rest = line:match("^(%s*)(" .. bullet .. ")%s+(.*)$")
    if indent then
      return vim.api.nvim_set_current_line(("%s%s [ ] %s"):format(indent, b, rest))
    end
  end

  local indent, rest = line:match "^(%s*)(.*)$"
  vim.api.nvim_set_current_line(indent .. "- [ ] " .. rest)
end

return M
