-- ── Volver atrás tras saltar (gd / grr / Ctrl+click) + historial de archivos ──
-- 1) Pila "peek": cada salto guarda de dónde vino; <Esc> en el destino vuelve (solo
--    mientras no hayas editado ahí ni te hayas ido a otro buffer; varios saltos
--    encadenados se deshacen de uno en uno).
-- 2) Historial de la sesión: últimos archivos visitados (<leader>H los lista).
local log = require "utils.log"

local M = {}

local MAX_STACK = 20
local MAX_HISTORY = 10

---@class nav.Origin
---@field buf integer
---@field pos integer[] {línea, columna}

---@type { origin: nav.Origin, buf: integer, tick: integer }[]
local stack = {}

--- Punto actual; llamar ANTES de saltar.
---@return nav.Origin
function M.origin()
  return { buf = vim.api.nvim_get_current_buf(), pos = vim.api.nvim_win_get_cursor(0) }
end

--- Registrar que se saltó desde `origin` hasta donde está el cursor ahora.
---@param origin nav.Origin
function M.landed(origin)
  local buf = vim.api.nvim_get_current_buf()
  if buf == origin.buf and vim.api.nvim_win_get_cursor(0)[1] == origin.pos[1] then
    return -- no se movió
  end
  table.insert(stack, { origin = origin, buf = buf, tick = vim.b[buf].changedtick })
  if #stack > MAX_STACK then
    table.remove(stack, 1)
  end
end

--- Volver al punto previo al último salto. false si no aplica (para que <Esc>
--- haga lo de siempre).
---@return boolean
function M.back()
  local top = stack[#stack]
  if not top then
    return false
  end

  local buf = vim.api.nvim_get_current_buf()
  if top.buf ~= buf or vim.b[buf].changedtick ~= top.tick or not vim.api.nvim_buf_is_valid(top.origin.buf) then
    stack = {} -- te moviste a otro sitio o editaste: ya no es un "vistazo"
    return false
  end

  table.remove(stack)
  vim.api.nvim_set_current_buf(top.origin.buf)
  pcall(vim.api.nvim_win_set_cursor, 0, top.origin.pos)
  vim.cmd "normal! zz"
  return true
end

-- ── Historial de archivos ────────────────────────────────────────────────────

---@type { path: string, lnum: integer }[] más reciente primero
local history = {}

local function is_file(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" then
    return nil
  end
  local path = vim.api.nvim_buf_get_name(buf)
  if path == "" or vim.fn.filereadable(path) == 0 then
    return nil
  end
  return path
end

--- Marca `buf` como el archivo más reciente.
---@param buf integer
function M.track(buf)
  local path = is_file(buf)
  if not path then
    return
  end
  local lnum = 1
  if buf == vim.api.nvim_get_current_buf() then
    lnum = vim.api.nvim_win_get_cursor(0)[1]
  end
  for i, entry in ipairs(history) do
    if entry.path == path then
      lnum = lnum == 1 and entry.lnum or lnum
      table.remove(history, i)
      break
    end
  end
  table.insert(history, 1, { path = path, lnum = lnum })
  if #history > MAX_HISTORY + 1 then -- +1: el archivo actual no se muestra
    table.remove(history)
  end
end

--- Guarda la línea donde se dejó `buf` (se llama al salir de él).
---@param buf integer
function M.save_position(buf)
  local path = is_file(buf)
  if not path or buf ~= vim.api.nvim_get_current_buf() then
    return
  end
  for _, entry in ipairs(history) do
    if entry.path == path then
      entry.lnum = vim.api.nvim_win_get_cursor(0)[1]
      return
    end
  end
end

--- Lista (con vista previa) de los últimos archivos visitados, sin el actual.
function M.history_picker()
  local current = vim.api.nvim_buf_get_name(0)
  local items = vim.tbl_filter(function(entry)
    return entry.path ~= current
  end, history)

  if #items == 0 then
    return log.info "You haven't visited any other files in this session yet"
  end

  local conf = require("telescope.config").values
  require("telescope.pickers")
    .new({
      prompt_title = "File history (most recent first)",
      sorting_strategy = "ascending",
      layout_config = { prompt_position = "top" },
    }, {
      finder = require("telescope.finders").new_table {
        results = items,
        entry_maker = function(entry)
          local rel = vim.fn.fnamemodify(entry.path, ":~:.")
          return {
            value = entry,
            display = ("%s:%d"):format(rel, entry.lnum),
            ordinal = rel,
            filename = entry.path,
            lnum = entry.lnum,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      previewer = conf.grep_previewer {},
    })
    :find()
end

return M
