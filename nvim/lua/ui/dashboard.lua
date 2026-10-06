-- ── Dashboard (nvdash de NvChad) ─────────────────────────────────────────────
-- Separado en: header (arte, ver ui/arts), info de git y botones de acción. Cada parte es
-- una función/tabla independiente; `buttons()` solo las compone.
local M = {}

--- Acciones: { texto, atajo, comando }
local ACTIONS = {
  { "  Find File", "ff", "Telescope find_files" },
  { "  Recent Files", "fo", "Telescope oldfiles" },
  { "  Find Word", "fw", "Telescope live_grep" },
  { "  Themes", "th", ":lua require('nvchad.themes').open()" },
  { "  Mappings", "ch", "NvCheatsheet" },
  { "  Change Art", "ca", "lua require('ui.arts').pick()" },
}

local function separator()
  return { txt = " ", hl = "NvDashFooter", no_gap = true, rep = true }
end

--- Repo (rama) y usuario de git, si el cwd está en un repositorio
---@return table[]
local function git_info()
  local info = require("utils.git").info()
  local lines = {}

  if info.repo ~= "" then
    local label = info.branch ~= "" and ("  %s (%s)"):format(info.repo, info.branch) or ("  " .. info.repo)
    table.insert(lines, { txt = label, hl = "NvDashFooter", no_gap = true, content = "fit" })
  end
  if info.user ~= "" then
    table.insert(lines, { txt = "  " .. info.user, hl = "Comment", no_gap = true, content = "fit" })
  end
  return lines
end

---@return table[]
local function action_buttons()
  return vim.tbl_map(function(action)
    return { txt = action[1], keys = action[2], cmd = action[3] }
  end, ACTIONS)
end

---@return table[]
function M.buttons()
  local buttons = { separator() }
  vim.list_extend(buttons, git_info())
  table.insert(buttons, separator())
  vim.list_extend(buttons, action_buttons())
  return buttons
end

--- Tabla `nvdash` para chadrc
---@return table
function M.config()
  return {
    load_on_startup = true,
    header = require("ui.arts").lines,
    buttons = M.buttons,
  }
end

return M
