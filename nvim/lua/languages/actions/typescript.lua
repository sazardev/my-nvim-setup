-- ── Acciones de TypeScript / JavaScript ──────────────────────────────────────
-- Detecta el gestor de paquetes (pnpm/yarn/bun/npm) por lockfile y usa los
-- scripts de package.json cuando existen.
local actions = require "utils.actions"
local log = require "utils.log"
local project = require "utils.project"
local terminal = require "utils.terminal"

local MARKERS = { "package.json", ".git" }

---@return string pm, string root
local function package_manager()
  local root = project.root(MARKERS)
  if project.has(root, "pnpm-lock.yaml") then
    return "pnpm", root
  elseif project.has(root, "yarn.lock") then
    return "yarn", root
  elseif project.has(root, "bun.lockb") or project.has(root, "bun.lock") then
    return "bun", root
  end
  return "npm", root
end

---@param root string
---@return string[]
local function scripts(root)
  local content = project.read(root .. "/package.json")
  local ok, pkg = pcall(vim.json.decode, content or "")
  local names = ok and type(pkg) == "table" and type(pkg.scripts) == "table" and vim.tbl_keys(pkg.scripts) or {}
  table.sort(names)
  return names
end

--- Corre el script de package.json si existe; si no, `fallback` (o avisa).
local function script(name, fallback)
  return function()
    local pm, root = package_manager()
    if vim.tbl_contains(scripts(root), name) then
      return terminal.float(("%s run %s"):format(pm, name), root)
    end
    if fallback then
      return terminal.float(fallback, root)
    end
    log.warn(("package.json no tiene el script `%s`"):format(name))
  end
end

local function pick_script()
  local pm, root = package_manager()
  local names = scripts(root)
  if #names == 0 then
    return log.warn "No hay scripts en package.json"
  end
  vim.ui.select(names, { prompt = pm .. " run" }, function(choice)
    if choice then
      terminal.float(("%s run %s"):format(pm, choice), root)
    end
  end)
end

local function pm_command(sub)
  return function()
    local pm, root = package_manager()
    terminal.float(pm .. " " .. sub, root)
  end
end

return {
  { "r", "run script…", pick_script },
  { "d", "dev", script "dev" },
  { "b", "build", script "build" },
  { "m", "test", pm_command "test" },
  { "v", "lint", script("lint", "npx --no-install eslint .") },
  { "c", "typecheck (tsc)", actions.run("npx", "npx --no-install tsc --noEmit", MARKERS) },
  {
    "x",
    "eslint --fix (archivo)",
    function()
      local _, root = package_manager()
      terminal.float("npx --no-install eslint --fix " .. vim.fn.shellescape(vim.fn.expand "%:p"), root)
    end,
  },
  { "f", "format", actions.format },
  { "o", "organize imports", actions.code_action "source.organizeImports" },
  { "i", "install deps", pm_command "install" },
}
