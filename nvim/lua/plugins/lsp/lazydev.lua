-- Tipos y completado de la API de Neovim y de los plugins al editar Lua (lua_ls).
-- Solo carga en archivos .lua; añade a lua_ls solo las librerías que el código usa.
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
