-- ── Acciones de Markdown ─────────────────────────────────────────────────────
local actions = require "utils.actions"
local log = require "utils.log"
local md = require "utils.markdown"

--- Muestra/oculta los diagnósticos (errores del linter) SOLO en este buffer: sirve
--- para leer el markdown "como libro". El linter sigue corriendo, solo se ocultan.
local function toggle_diagnostics()
  local on = not vim.diagnostic.is_enabled { bufnr = 0 }
  vim.diagnostic.enable(on, { bufnr = 0 })
  log.info("Diagnósticos de este buffer: " .. (on and "visibles" or "ocultos"))
end

return {
  { "r", "toggle render", actions.ex "RenderMarkdown toggle" },
  { "d", "toggle diagnostics (errores del linter)", toggle_diagnostics },
  { "z", "modo lectura (centrado, sin ruido)", md.reading_mode },
  { "s", "ortografía (es, en)", md.toggle_spell },
  { "w", "palabras y tiempo de lectura", md.word_count },
  { "x", "marcar/desmarcar checkbox", md.toggle_checkbox },
  { "o", "outline", actions.ex "AerialToggle" },
  { "f", "format", actions.format },
}
