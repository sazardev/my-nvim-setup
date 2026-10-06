-- ── Contexto Settings (global): <leader>S ────────────────────────────────────
-- Apariencia hoy; aquí se agregan futuros ajustes en caliente.
local function appearance()
  return require "appearance"
end

local default_name = require("core.settings").theme.name

return {
  name = "Settings",
  prefix = "S",
  global = true,
  maps = {
    {
      "t",
      "toggle theme",
      function()
        appearance().toggle()
      end,
    },
    {
      "d",
      "default theme (" .. default_name .. ")",
      function()
        if appearance().use(appearance().default()) then
          require("utils.log").info("Tema: " .. appearance().default())
        end
      end,
    },
    {
      "a",
      "terminal theme (Alacritty)",
      function()
        if appearance().use(appearance().TERMINAL) then
          require("utils.log").info "Tema: terminal"
        end
      end,
    },
    {
      "r",
      "re-sync terminal theme",
      function()
        if appearance().use(appearance().TERMINAL) then
          require("utils.log").info "Tema terminal re-sincronizado"
        end
      end,
    },
    {
      "p",
      "theme picker",
      function()
        require("nvchad.themes").open()
      end,
    },
    {
      "i",
      "theme info",
      function()
        require("utils.log").info(appearance().info())
      end,
    },
  },
}
