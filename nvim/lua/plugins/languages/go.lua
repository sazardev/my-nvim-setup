-- go.nvim: no se carga en modo ligero (residente y pesado).
return {
  "ray-x/go.nvim",
  dependencies = { "ray-x/guihua.lua" },
  ft = { "go", "gomod", "gowork" },
  cond = function()
    return not require("core.light").enabled
  end,
  build = ':lua require("go.install").update_all_sync()',
  config = function()
    require("go").setup()
  end,
}
