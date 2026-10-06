-- Telescope: respeta .gitignore en búsquedas, sin íconos en resultados.
local no_icons = require("utils.telescope").no_icons

-- Directorios que nunca queremos en find_files
local EXCLUDED = { ".git", "node_modules", ".next", "dist", "build", "vendor", "target", ".cache", ".nuxt", "coverage" }

local function find_command()
  local cmd = { "rg", "--files", "--hidden", "--no-ignore" }
  for _, dir in ipairs(EXCLUDED) do
    vim.list_extend(cmd, { "--glob", "!" .. dir })
  end
  return cmd
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
      enabled = vim.fn.executable "cmake" == 1,
    },
  },
  opts = {
    defaults = {
      path_display = { "truncate" },
      prompt_prefix = "> ",
      selection_caret = "  ",
      layout_config = { width = 0.9, height = 0.9 },
    },
    pickers = {
      find_files = {
        hidden = true,
        entry_maker = no_icons(),
        find_command = find_command(),
      },
      buffers = { entry_maker = no_icons() },
      oldfiles = { entry_maker = no_icons() },
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
  end,
}
