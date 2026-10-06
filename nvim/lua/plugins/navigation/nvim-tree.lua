-- Explorador: oculta git-ignored (rápido), sin íconos.
local function on_attach(bufnr)
  local api = require "nvim-tree.api"

  api.config.mappings.default_on_attach(bufnr)

  -- <CR> sobre un archivo → abre y cierra nvim-tree
  vim.keymap.set("n", "<CR>", function()
    local node = api.tree.get_node_under_cursor()
    api.node.open.edit()
    if not node.nodes then
      api.tree.close()
    end
  end, { buffer = bufnr, desc = "nvim-tree: Open file and close tree", nowait = true })
end

return {
  "nvim-tree/nvim-tree.lua",
  opts = {
    filters = {
      dotfiles = true,
      git_ignored = true,
    },
    renderer = {
      icons = {
        show = {
          file = false,
          folder = false,
          folder_arrow = false,
          git = false,
        },
      },
    },
    on_attach = on_attach,
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
  end,
}
