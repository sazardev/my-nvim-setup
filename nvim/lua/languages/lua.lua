return {
  filetypes = { "lua" },
  treesitter = { "lua", "vim", "vimdoc" },
  lsp = { "lua_ls" }, -- NvChad ya lo habilita; aquí queda declarado
  mason = { full = { "lua-language-server" }, always = { "stylua" } },
  formatters = { lua = { "stylua" } },
}
