-- ── Acciones de Markdown ─────────────────────────────────────────────────────
local actions = require "utils.actions"

return {
  { "r", "toggle render", actions.ex "RenderMarkdown toggle" },
  { "o", "outline", actions.ex "AerialToggle" },
  { "f", "format", actions.format },
}
