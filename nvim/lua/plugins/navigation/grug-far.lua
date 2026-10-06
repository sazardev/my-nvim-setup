-- Reemplazo global estilo VS Code
return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    { "<leader>fr", "<cmd>GrugFar<cr>", desc = "replace" },
  },
  opts = {
    keymaps = {
      close = { n = "q" },
    },
  },
  config = function(_, opts)
    require("grug-far").setup(opts)
  end,
}
