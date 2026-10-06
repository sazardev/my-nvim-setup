return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signcolumn = false, -- sin signs en signcolumn
    numhl = true, -- número de línea cambia de color (gruvbox)
    linehl = false, -- sin highlight en la línea entera
    current_line_blame = false,
    update_debounce = 100, -- debounce = menos redraws
  },
  config = function(_, opts)
    require("gitsigns").setup(opts)
  end,
}
