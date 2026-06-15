-- entry_maker reutilizable que saca los íconos de telescope.
-- Por qué existe: los íconos vienen de nvim-web-devicons, no se desactivan
-- con un flag, hay que pisar el entry_maker que arma cada resultado.

local entry_display = require("telescope.pickers.entry_display")

local M = {}

function M.no_icons()
  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 1 },        -- padding (antes era el ícono)
      { remaining = true }, -- path completo
    },
  })

  return function(entry)
    local path = entry.path or entry.value
    return {
      value = entry,
      path = path,
      ordinal = path,
      display = function(e)
        return displayer({
          { " " },
          e.path,
        })
      end,
    }
  end
end

return M