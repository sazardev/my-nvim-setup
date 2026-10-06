-- Popup de keymaps. Los menús por lenguaje/git son buffer-locales (lua/menus/).
return {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup {
      delay = 0,
      icons = {
        mappings = false,
      },
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>h", group = "Harpoon" },

        -- Prefijos de NvChad que no queremos ver en el popup
        { "<leader>v", hidden = true },
        { "<leader>wK", hidden = true },
        { "<leader>wk", hidden = true },
        { "<leader>c", hidden = true },
        { "<leader>o", hidden = true },
        { "<leader>b", hidden = true },
        { "<leader>n", hidden = true },

        -- Keymaps deshabilitados dentro de grupos visibles
        { "<leader>fa", hidden = true },
        { "<leader>fz", hidden = true },
        { "<leader>fh", hidden = true },
        { "<leader>fc", hidden = true },
        { "<leader>xb", hidden = true },
      },
    }
  end,
}
