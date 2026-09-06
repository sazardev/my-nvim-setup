-- entry_maker reutilizable que saca los íconos de telescope.
-- Por qué existe: los íconos vienen de nvim-web-devicons, no se desactivan
-- con un flag, hay que pisar el entry_maker que arma cada resultado.
--
-- IMPORTANTE: el require de telescope se hace DENTRO del closure de display.
-- Si se hiciera al nivel del módulo, fallaría en una instalación limpia:
-- lazy evalúa los specs ANTES de tener telescope en el runtimepath.

local M = {}

function M.no_icons()
  -- memo: se crea el displayer solo la primera vez que se muestra un entry
  local displayer

  return function(line)
    -- line es el string crudo que viene de rg (ej: "src/foo.go")
    local path = line
    return {
      value = path,
      path = path,
      ordinal = path,
      display = function(e)
        if not displayer then
          local entry_display = require("telescope.pickers.entry_display")
          displayer = entry_display.create({
            separator = " ",
            items = {
              { width = 1 },        -- padding (antes era el ícono)
              { remaining = true }, -- path completo
            },
          })
        end

        return displayer({
          { "" },
          e.path,
        })
      end,
    }
  end
end

return M
