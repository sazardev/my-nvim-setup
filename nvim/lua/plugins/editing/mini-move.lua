-- Mover líneas/bloques con Alt+hjkl
local DIRECTIONS = { h = "left", j = "down", k = "up", l = "right" }

local keys, mappings = {}, {}
for key, direction in pairs(DIRECTIONS) do
  local lhs = "<A-" .. key .. ">"
  table.insert(keys, { lhs, mode = { "n", "v" }, desc = "Move " .. direction })
  mappings[direction] = lhs
end

return {
  "echasnovski/mini.move",
  keys = keys,
  opts = { mappings = mappings },
  config = function(_, opts)
    require("mini.move").setup(opts)
  end,
}
