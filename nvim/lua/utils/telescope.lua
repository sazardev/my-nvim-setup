-- ── entry_maker de telescope sin íconos ──────────────────────────────────────
-- Los íconos vienen de nvim-web-devicons y no se desactivan con un flag: hay
-- que pisar el entry_maker que arma cada resultado.
--
-- IMPORTANTE: el require de telescope va DENTRO del closure de display. A nivel
-- de módulo fallaría en una instalación limpia: lazy evalúa los specs ANTES de
-- tener telescope en el runtimepath.
local M = {}

---@return fun(line: string): table
function M.no_icons()
  local displayer -- memo: se crea la primera vez que se muestra un entry

  return function(line)
    return {
      value = line,
      path = line,
      ordinal = line,
      display = function(entry)
        if not displayer then
          displayer = require("telescope.pickers.entry_display").create {
            separator = " ",
            items = {
              { width = 1 }, -- padding (antes era el ícono)
              { remaining = true }, -- path completo
            },
          }
        end
        return displayer { { "" }, entry.path }
      end,
    }
  end
end

return M
