-- Terminal flotante: lo usan los menús por lenguaje (utils/terminal.lua) y lazydocker.
return {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TermExec" },
  opts = {
    size = 0.6,
    open_mapping = false,
    direction = "float",
    float_opts = { border = "single" },
    close_on_exit = true,
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)
    -- Esc en terminal cierra la ventana flotante
    vim.keymap.set("t", "<Esc>", "<cmd>lua require('toggleterm').toggle()<cr>", { desc = "Close terminal (Esc)" })
  end,
}
