-- Folding semántico (treesitter + indent, sin LSP extra)
return {
  "kevinhwang91/nvim-ufo",
  event = "BufReadPost",
  dependencies = { "kevinhwang91/promise-async" },
  opts = {
    provider_selector = function()
      return { "treesitter", "indent" }
    end,
  },
  config = function(_, opts)
    vim.o.foldcolumn = "0"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    require("ufo").setup(opts)
  end,
}
