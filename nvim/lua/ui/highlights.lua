-- ── Overrides de highlights (base46) ─────────────────────────────────────────
-- Los colores se refieren a la paleta del tema (base0C, orange...).
local M = {}

-- Funciones: el tema usaba base0D (azul apagado) para nombres/llamadas.
-- Se cambia al aqua vivo (base0C, ya usado en @constructor) + bold.
local FUNCTION_GROUPS = {
  "Function",
  "@function",
  "@function.builtin",
  "@function.call",
  "@function.method",
  "@function.method.call",
}

-- Operadores: el tema los pintaba con el mismo azul que las funciones.
local OPERATOR_GROUPS = { "Operator", "@operator" }

---@return table
function M.overrides()
  local hl = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    St_gitIcons = { fg = "white", bg = "lightbg", bold = true },
  }
  for _, group in ipairs(FUNCTION_GROUPS) do
    hl[group] = { fg = "base0C", bold = true }
  end
  for _, group in ipairs(OPERATOR_GROUPS) do
    hl[group] = { fg = "orange" }
  end
  return hl
end

return M
