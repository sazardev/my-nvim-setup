-- astro-ls exige typescript.tsdk: primero el typescript del proyecto y, si no
-- hay node_modules, el que trae el paquete de Mason (evita el error de init).
return {
  filetypes = { "astro" },
  before_init = function(_, config)
    local ts = config.init_options and config.init_options.typescript
    if not ts or ts.tsdk then
      return
    end
    local project_ts = vim.fs.find("node_modules/typescript/lib", {
      path = config.root_dir,
      upward = true,
      type = "directory",
    })[1]
    ts.tsdk = project_ts
      or (vim.fn.stdpath "data" .. "/mason/packages/astro-language-server/node_modules/typescript/lib")
  end,
}
