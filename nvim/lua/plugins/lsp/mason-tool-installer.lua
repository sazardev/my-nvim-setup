-- Auto-instala los paquetes que declaran los lenguajes (lua/languages/).
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  lazy = false,
  dependencies = { "mason-org/mason.nvim" },
  opts = {
    ensure_installed = require("languages").mason(),
    auto_update = false,
    run_on_start = false, -- tools ya instalados; no checar versiones en cada arranque
  },
  config = function(_, opts)
    require("mason-tool-installer").setup(opts)
  end,
}
