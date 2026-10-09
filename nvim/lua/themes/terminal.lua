-- Tema "terminal": base46 lo carga como `themes.terminal` (lua/themes/ es su
-- carpeta de temas de usuario). La lógica vive en lua/appearance/.
local loaded = require("appearance.alacritty").load()
if not loaded then
  error "terminal theme: Alacritty config not found"
end

local theme =
  require("appearance.terminal_theme").build(loaded.palette, require("core.settings").theme.terminal.min_contrast)

return require("base46").override_theme(theme, "terminal")
