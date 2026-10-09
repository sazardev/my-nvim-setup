-- ── Arte ASCII del dashboard ─────────────────────────────────────────────────
-- Catálogo: un archivo por arte en `lua/ui/arts/<nombre>.lua` que devuelve la
-- lista de líneas. Para añadir uno: solo crea el archivo; el catálogo se descubre
-- escaneando la carpeta (sin lista que mantener) cada vez que se necesita.
-- IMPORTANTE: todo arte debe ser de PUNTOS (caracteres braille U+2800–U+28FF),
-- nunca ASCII/bloques/emoji, para mantener el mismo estilo en el dashboard.
-- La elección se recuerda entre sesiones (stdpath "state"/dashboard.json); el
-- valor inicial es `settings.dashboard.art`.
local log = require "utils.log"
local settings = require "core.settings"

local M = {}

--- Artes disponibles: un `<nombre>.lua` por arte en esta carpeta (excepto init).
---@return string[] nombres ordenados
function M.names()
  local names, seen = {}, {}
  for _, path in ipairs(vim.api.nvim_get_runtime_file("lua/ui/arts/*.lua", true)) do
    local name = vim.fn.fnamemodify(path, ":t:r")
    if name ~= "init" and not seen[name] then
      seen[name] = true
      table.insert(names, name)
    end
  end
  table.sort(names)
  return names
end

local function state_path()
  return vim.fn.stdpath "state" .. "/dashboard.json"
end

---@return string?
local function read_saved()
  local f = io.open(state_path(), "r")
  if not f then
    return nil
  end
  local ok, data = pcall(vim.json.decode, f:read "*a")
  f:close()
  return ok and type(data) == "table" and data.art or nil
end

---@param name string
local function write_saved(name)
  vim.fn.mkdir(vim.fs.dirname(state_path()), "p")
  local f = io.open(state_path(), "w")
  if f then
    f:write(vim.json.encode { art = name })
    f:close()
  end
end

---@param name string
---@return boolean
local function valid(name)
  return vim.tbl_contains(M.names(), name)
end

---@return string nombre elegido
function M.current()
  local saved = read_saved()
  if saved and valid(saved) then
    return saved
  end
  return valid(settings.dashboard.art) and settings.dashboard.art or M.names()[1]
end

--- Rellena las líneas al mismo ancho: nvdash centra cada línea por separado y
--- un arte con líneas desiguales se vería torcido.
---@param lines string[]
---@return string[]
local function pad(lines)
  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  return vim.tbl_map(function(l)
    return l .. string.rep(" ", width - vim.fn.strdisplaywidth(l))
  end, lines)
end

---@param name string
---@return string[]
function M.load(name)
  -- sin caché: así un arte editado se ve al reabrir el selector sin reiniciar nvim
  package.loaded["ui.arts." .. name] = nil
  local ok, lines = pcall(require, "ui.arts." .. name)
  if not ok or type(lines) ~= "table" then
    log.warn(("Arte '%s' no se pudo cargar"):format(name))
    return {}
  end
  return pad(lines)
end

---@return string[] líneas del arte activo
function M.lines()
  return M.load(M.current())
end

--- Redibuja el dashboard si está visible. nvdash reemplaza `header` por su
--- resultado en el primer dibujo, así que hay que volver a ponerle la función.
local function redraw()
  local buf = vim.g.nvdash_buf
  local win = buf and vim.api.nvim_buf_is_valid(buf) and vim.fn.bufwinid(buf) or -1
  if win == -1 then
    return
  end
  require("nvconfig").nvdash.header = M.lines
  vim.api.nvim_buf_clear_namespace(buf, vim.api.nvim_create_namespace "nvdash", 0, -1)
  local modifiable = vim.bo[buf].modifiable
  vim.bo[buf].modifiable = true
  require("nvchad.nvdash").open(buf, win, "redraw")
  vim.bo[buf].modifiable = modifiable
end

---@param name string
function M.set(name)
  if not valid(name) then
    return log.warn(("Arte desconocido: %s"):format(name))
  end
  write_saved(name)
  redraw()
  log.info("Arte del dashboard: " .. name)
end

--- Selector con vista previa (Telescope); cae a vim.ui.select sin Telescope.
function M.pick()
  local ok, pickers = pcall(require, "telescope.pickers")
  if not ok then
    return vim.ui.select(M.names(), { prompt = "Arte del dashboard" }, function(choice)
      if choice then
        M.set(choice)
      end
    end)
  end

  local finders = require "telescope.finders"
  local previewers = require "telescope.previewers"
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local conf = require("telescope.config").values

  local names = M.names()
  pickers
    .new({}, {
      prompt_title = "Arte del dashboard",
      finder = finders.new_table { results = names },
      sorter = conf.generic_sorter {},
      default_selection_index = (vim.fn.index(names, M.current()) + 1),
      layout_strategy = "horizontal",
      layout_config = { width = 0.7, height = 0.6, preview_width = 0.6 },
      previewer = previewers.new_buffer_previewer {
        title = "Vista previa",
        define_preview = function(self, entry)
          local lines = M.load(entry[1])
          local buf = self.state.bufnr
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          for i = 1, #lines do
            vim.api.nvim_buf_add_highlight(buf, -1, "NvDashAscii", i - 1, 0, -1)
          end
        end,
      },
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if entry then
            M.set(entry[1])
          end
        end)
        return true
      end,
    })
    :find()
end

return M
