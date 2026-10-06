-- Auto-cierre y renombrado de tags JSX/HTML
return {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
  config = function(_, opts)
    require("nvim-ts-autotag").setup(opts)
  end,
}
