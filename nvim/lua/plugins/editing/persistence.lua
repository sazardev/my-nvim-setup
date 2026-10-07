-- Sesiones por carpeta (y rama de git): guarda buffers y ventanas al salir.
-- Se restauran a demanda (botón del dashboard, <leader>P): ver utils/session.lua.
return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  config = function(_, opts)
    require("persistence").setup(opts)

    -- Antes de guardar se cierran las ventanas auxiliares (árbol, outline, terminal...):
    -- una sesión no sabe reconstruirlas y las restauraría como ventanas vacías.
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("PersistenceCleanup", { clear = true }),
      pattern = "PersistenceSavePre",
      callback = function()
        require("utils.session").close_auxiliary()
      end,
    })
  end,
}
