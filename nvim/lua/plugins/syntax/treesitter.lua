-- Parsers declarados en lua/languages/ (campo `treesitter`).
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = require("languages").treesitter(),
  },
  config = function(_, opts)
    -- La API nueva de nvim-treesitter (rama "main") ya NO instala sola los
    -- parsers listados en ensure_installed dentro de .setup(): hay que pedirlo
    -- explícito con .install(). Requiere además el binario `tree-sitter`
    -- (paquete `tree-sitter-cli`) en el sistema, no solo un compilador de C.
    require("nvim-treesitter").setup {}
    require("nvim-treesitter").install(opts.ensure_installed)
  end,
}
