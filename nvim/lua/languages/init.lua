-- ── Registro de lenguajes ────────────────────────────────────────────────────
-- Un lenguaje = un archivo en lua/languages/<nombre>.lua que DECLARA (no
-- ejecuta) lo que necesita. Este módulo agrega esas declaraciones y las expone
-- a cada consumidor (treesitter, mason, lsp, conform, nvim-lint, menús), de modo
-- que añadir un lenguaje nunca obliga a editar otro archivo (open/closed).
--
-- Contrato de un lenguaje (todos los campos son opcionales):
--   filetypes   string[]            filetypes que cubre (para menús y plugins)
--   treesitter  string[]            parsers de nvim-treesitter
--   lsp         string[]            servidores (lua/servers/<n>.lua = overrides)
--   mason       { always?, full? }  paquetes; `always` también en modo ligero
--   formatters  table<ft, string[]> conform
--   linters     table<ft, string[]> nvim-lint
--   linters_light table<ft, string[]> sustituye a `linters` en modo ligero
--   setup_lint  fun(lint)           registra linters personalizados
--   menu        { name, prefix, maps = {{key, desc, fn}...} }  menú del leader
local settings = require "core.settings"
local light = require("core.light").enabled

local M = {}

-- Orden de carga. Para añadir un lenguaje: crea su archivo y agrégalo aquí.
local NAMES = {
  "lua",
  "go",
  "typescript",
  "html",
  "css",
  "tailwind",
  "json",
  "yaml",
  "toml",
  "markdown",
  "docker",
  "prisma",
  "astro",
  "dart",
  "rust",
  "python",
  "java",
  "kotlin",
  "yarnspinner",
}

---@type table[]?
local cache

---@return table[]
local function all()
  if cache then
    return cache
  end
  cache = {}
  for _, name in ipairs(NAMES) do
    if not vim.tbl_contains(settings.languages.disabled, name) then
      local spec = require("languages." .. name)
      spec.name = spec.name or name
      table.insert(cache, spec)
    end
  end
  return cache
end

---@param list string[]
---@return string[]
local function unique(list)
  local seen, out = {}, {}
  for _, item in ipairs(list) do
    if not seen[item] then
      seen[item] = true
      table.insert(out, item)
    end
  end
  return out
end

---@param field string
---@return string[]
local function collect(field)
  local out = {}
  for _, lang in ipairs(all()) do
    vim.list_extend(out, lang[field] or {})
  end
  return unique(out)
end

---@return table[]
function M.list()
  return all()
end

---@return string[]
function M.treesitter()
  return collect "treesitter"
end

--- Servidores LSP a habilitar (ninguno en modo ligero)
---@return string[]
function M.lsp_servers()
  if light then
    return {}
  end
  return collect "lsp"
end

--- Paquetes de Mason (solo `always` en modo ligero)
---@return string[]
function M.mason()
  local out = {}
  for _, lang in ipairs(all()) do
    local mason = lang.mason or {}
    vim.list_extend(out, mason.always or {})
    if not light then
      vim.list_extend(out, mason.full or {})
    end
  end
  return unique(out)
end

--- Une los mapas ft -> herramientas de todos los lenguajes
---@param fields string[] campos en orden de precedencia creciente
---@return table<string, string[]>
local function merge_by_filetype(fields)
  local out = {}
  for _, lang in ipairs(all()) do
    for _, field in ipairs(fields) do
      for ft, tools in pairs(lang[field] or {}) do
        out[ft] = tools
      end
    end
  end
  return out
end

---@return table<string, string[]>
function M.formatters()
  return merge_by_filetype { "formatters" }
end

--- En modo ligero `linters_light` sustituye a `linters` solo en los ft que define
---@return table<string, string[]>
function M.linters()
  return merge_by_filetype(light and { "linters", "linters_light" } or { "linters" })
end

--- Registra los linters personalizados de cada lenguaje
---@param lint table módulo nvim-lint
function M.setup_lint(lint)
  for _, lang in ipairs(all()) do
    if lang.setup_lint then
      lang.setup_lint(lint)
    end
  end
end

--- Contextos de menú (un menú por lenguaje que lo declare)
---@return table[]
function M.menus()
  local out = {}
  for _, lang in ipairs(all()) do
    if lang.menu then
      table.insert(out, vim.tbl_extend("keep", { filetypes = lang.filetypes }, lang.menu))
    end
  end
  return out
end

return M
