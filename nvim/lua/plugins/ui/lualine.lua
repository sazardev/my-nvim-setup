-- Statusline (reemplaza la de NvChad). El tema sale de base46: ui/lualine/theme.lua
local components = require "ui.lualine.components"

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      theme = "auto", -- se resuelve en config() leyendo base46
      section_separators = "",
      component_separators = "",
      globalstatus = true,
      refresh = {
        statusline = 200,
        winbar = 200,
        tabline = 200,
        underline = 1000,
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "filename" },
      lualine_c = { { "branch", icon = "" } },
      lualine_x = {
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = "E", warn = "W" },
          diagnostics_color = {
            error = "DiagnosticError",
            warn = "DiagnosticWarn",
          },
          colored = true,
          sections = { "error", "warn" },
        },
      },
      lualine_y = {
        { components.lsp_clients, cond = components.has_lsp },
        { components.project_name, cond = components.is_wide },
      },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = { "filename" },
      lualine_c = {},
      lualine_x = { "filetype" },
      lualine_y = {},
      lualine_z = { "location" },
    },
  },
  config = function(_, opts)
    local theme = require "ui.lualine.theme"

    opts.options.theme = theme.build()
    require("lualine").setup(opts)

    -- Re-aplica el tema si NvChad recarga colores (p. ej. theme_toggle)
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("LualineNvChadTheme", { clear = true }),
      callback = function()
        local ok, lualine = pcall(require, "lualine")
        if ok then
          lualine.setup { options = { theme = theme.build() } }
        end
      end,
    })
  end,
}
