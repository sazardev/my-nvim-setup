-- Añadir/quitar/cambiar delimitadores: sa / sd / sr
return {
  "echasnovski/mini.surround",
  keys = {
    { "sa", mode = { "n", "x" }, desc = "Add surrounding" },
    { "sd", mode = "n", desc = "Delete surrounding" },
    { "sr", mode = "n", desc = "Replace surrounding" },
  },
  opts = {
    mappings = {
      add = "sa",
      delete = "sd",
      find = "sf",
      find_left = "sF",
      highlight = "sh",
      replace = "sr",
      update_n_lines = "sn",
    },
  },
  config = function(_, opts)
    require("mini.surround").setup(opts)
  end,
}
