-- Resolver conflictos de merge (ours/theirs/both/none) sin editar los marcadores.
-- Los atajos viven en el menú <leader>G (menus/git.lua): los por defecto (`co`, `cb`...)
-- pisarían los operadores `c` de nvim.
return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = "BufReadPost",
  opts = {
    default_mappings = false,
  },
}
