-- ── Errores centinela de Go: texto fantasma en vivo ──────────────────────────
-- Al escribir el NOMBRE de un error, el resto de la declaración aparece solo,
-- en gris a la derecha del cursor, y crece con cada letra:
--   ErrDescriptionTooLong|   →   ErrDescriptionTooLong = errors.New("description too long")
-- Tab lo acepta (cursor al final de la línea); Enter lo acepta y abre línea nueva.
-- Sigue tecleando y la sugerencia se ajusta; Esc la descarta.
--   dentro de `var ( … )`   ErrNotFound
--   tras `var `             var ErrNotFound
--   a nivel de paquete      ErrNotFound      (se antepone `var `)
-- Acepta también el nombre sin exportar (`errNotFound`).
local M = {}

local NS = vim.api.nvim_create_namespace "goerrors"
local SCAN_LINES = 300 -- cuánto se mira hacia arriba buscando el `var (`

--- "NotFound" → "not found", "InvalidID" → "invalid id", "HTTPError" → "http error"
---@param name string # con o sin el prefijo `Err`
---@return string
function M.message(name)
  local rest = name:gsub("^[eE]rr", "")
  rest = rest:gsub("_", " "):gsub("(%l)(%u)", "%1 %2"):gsub("(%u+)(%u%l)", "%1 %2"):gsub("(%d)(%a)", "%1 %2")
  return (rest:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""):lower())
end

--- ¿La línea `row` cae dentro de un `var ( … )` de nivel de paquete?
--- Se mira el texto, no treesitter: la línea que se está tecleando (`ErrX` suelto)
--- no parsea y deja el árbol roto justo donde hace falta.
---@param row integer 1-indexed
---@return boolean
local function in_var_block(row)
  local first = math.max(row - 1 - SCAN_LINES, 0)
  local lines = vim.api.nvim_buf_get_lines(0, first, row - 1, false)
  for i = #lines, 1, -1 do
    local line = lines[i]
    if line:match "^var%s*%(%s*$" or line:match "^var%s*%(%s*//" then
      return true
    elseif line:match "^%)" or line:match "^%a" then
      return false -- cerró el bloque, o es otra declaración en la columna 0
    end
  end
  return false
end

---@class GoErrorContext
---@field name string # el nombre tecleado (`ErrNotFound`)
---@field start integer # columna (0-indexed) donde empieza el nombre
---@field prefix string # texto que va ANTES del nombre al aceptar (`var ` o nada)
---@field suffix string # texto que va DESPUÉS (` = errors.New("not found")`)

--- ¿Se está declarando un error por su nombre, con el cursor al final de la línea? (nil = no)
---@param line string
---@param row integer 1-indexed
---@param col integer 0-indexed
---@return GoErrorContext?
function M.context(line, row, col)
  if line:sub(col + 1):find "%S" then
    return nil
  end
  local before = line:sub(1, col)
  local function build(name, start, prefix)
    return { name = name, start = start, prefix = prefix, suffix = (' = errors.New("%s")'):format(M.message(name)) }
  end
  local name = before:match "^var%s+([eE]rr%u[%w_]*)$"
  if name then
    return build(name, col - #name, "")
  end
  local indent
  indent, name = before:match "^(%s*)([eE]rr%u[%w_]*)$"
  if not name then
    return nil
  end
  if in_var_block(row) then
    return build(name, #indent, "")
  elseif indent == "" then
    return build(name, 0, "var ")
  end
end

---@return GoErrorContext?, integer?, integer? # contexto, fila (1-indexed), columna
local function current()
  if vim.bo.filetype ~= "go" or vim.api.nvim_get_mode().mode ~= "i" then
    return nil
  end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  return M.context(vim.api.nvim_get_current_line(), row, col), row, col
end

--- ¿Hay una sugerencia a la vista? (blink la usa para ocultar su menú)
---@return boolean
function M.active()
  return current() ~= nil
end

local function clear(buf)
  vim.api.nvim_buf_clear_namespace(buf or 0, NS, 0, -1)
end

local function render()
  local buf = vim.api.nvim_get_current_buf()
  clear(buf)
  local err, row, col = current()
  if not err then
    return
  end
  local ghost = { { err.suffix, "Comment" } }
  vim.api.nvim_buf_set_extmark(buf, NS, row - 1, col, { virt_text = ghost, virt_text_pos = "inline", hl_mode = "combine" })
  if err.prefix ~= "" then
    local pre = { { err.prefix, "Comment" } }
    vim.api.nvim_buf_set_extmark(buf, NS, row - 1, err.start, { virt_text = pre, virt_text_pos = "inline", hl_mode = "combine" })
  end
end

--- Escribe la sugerencia. Devuelve false si no había ninguna (para que la tecla siga su camino).
--- Blink llama esto desde un mapping `expr` (con el texto bloqueado), así que la edición se agenda.
---@param newline? boolean # además abre una línea nueva (Enter)
---@return boolean
function M.accept(newline)
  local err, row = current()
  if not err then
    return false
  end
  vim.schedule(function()
    clear()
    local line = vim.api.nvim_get_current_line()
    -- primero el sufijo (a la derecha), luego el prefijo: así las columnas no se corren
    vim.api.nvim_buf_set_text(0, row - 1, #line, row - 1, #line, { err.suffix })
    if err.prefix ~= "" then
      vim.api.nvim_buf_set_text(0, row - 1, err.start, row - 1, err.start, { err.prefix })
    end
    vim.api.nvim_win_set_cursor(0, { row, #vim.api.nvim_get_current_line() })
    if newline then
      vim.api.nvim_feedkeys(vim.keycode "<CR>", "n", false)
    end
  end)
  return true
end

--- Dibuja la sugerencia mientras se teclea. Llamar una vez al arrancar.
function M.setup()
  local group = vim.api.nvim_create_augroup("GoErrors", { clear = true })
  vim.api.nvim_create_autocmd({ "InsertEnter", "TextChangedI", "TextChangedP", "CursorMovedI" }, {
    group = group,
    pattern = "*.go",
    callback = render,
  })
  vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave" }, {
    group = group,
    pattern = "*.go",
    callback = function(args)
      clear(args.buf)
    end,
  })
end

return M
