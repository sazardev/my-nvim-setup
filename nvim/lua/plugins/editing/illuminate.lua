-- Ilumina todas las ocurrencias de la palabra bajo el cursor
return {
  "RRethy/vim-illuminate",
  event = { "CursorHold", "CursorHoldI" },
  opts = {
    delay = 200,
    filetypes_denylist = { "NvimTree", "TelescopePrompt", "alpha", "dashboard", "lazy", "mason", "nvdash" },
  },
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
}
