-- ── Navegación LSP con mensajes claros ───────────────────────────────────────
-- vim.lsp.buf.definition() & co. lanzan un error con "Press ENTER" cuando el
-- buffer no tiene servidor (markdown, yaml...), el servidor aún arranca o no
-- soporta el método. Aquí se explica en una línea qué pasa en cada caso.
local log = require "utils.log"
local nav = require "utils.navigation"

local M = {}

--- ¿Algún cliente del buffer soporta `method`? Si no, avisa por qué y devuelve false.
---@param method string
---@param what string acción, para el mensaje ("ir a definición"...)
---@return boolean
local function supported(method, what)
  local buf = vim.api.nvim_get_current_buf()

  if #vim.lsp.get_clients { bufnr = buf, method = method } > 0 then
    return true
  end

  local clients = vim.lsp.get_clients { bufnr = buf }
  if #clients == 0 then
    log.warn(("No LSP for this file (%s): can't %s"):format(vim.bo[buf].filetype, what))
    return false
  end

  local names = table.concat(
    vim.tbl_map(function(client)
      return client.name
    end, clients),
    ", "
  )
  local starting = vim.tbl_filter(function(client)
    return not client.initialized
  end, clients)

  if #starting > 0 then
    log.warn(("%s is still starting; try again in a few seconds"):format(names))
  else
    log.warn(("%s doesn't support: %s"):format(names, what))
  end
  return false
end

--- Opciones comunes de los pickers: sin íconos, siempre lista (aunque haya 1 resultado).
--- Disposición vertical: resultados a todo el ancho (no recorta las líneas) y
--- vista previa debajo.
local PICKER = {
  disable_devicons = true,
  jump_type = "never",
  show_line = true,
  fname_width = 40,
  layout_strategy = "vertical",
  layout_config = { preview_height = 0.5, preview_cutoff = 1, mirror = false },
}

--- Opciones de picker que registran el salto de Enter para poder volver con <Esc>.
---@param origin nav.Origin
local function with_back(origin)
  return vim.tbl_extend("force", PICKER, {
    attach_mappings = function()
      require("telescope.actions").select_default:enhance {
        post = function()
          nav.landed(origin)
        end,
      }
      return true
    end,
  })
end

--- Ir a la definición del símbolo bajo el cursor. Un solo destino: salta y <Esc>
--- vuelve; varios: quickfix (como el comportamiento por defecto).
function M.goto_definition()
  if not supported("textDocument/definition", "go to definition") then
    return
  end

  local origin = nav.origin()
  vim.lsp.buf.definition {
    on_list = function(result)
      if #result.items == 0 then
        return log.info(("Definition of '%s' not found"):format(vim.fn.expand "<cword>"))
      end
      if #result.items > 1 then
        vim.fn.setqflist({}, " ", result)
        return vim.cmd "botright copen"
      end
      local client = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/definition" })[1]
      vim.lsp.util.show_document(result.items[1].user_data, client.offset_encoding, { reuse_win = true, focus = true })
      nav.landed(origin)
    end,
  }
end

--- Pregunta al servidor primero: si no hay resultados lo explica en una línea (el
--- mensaje genérico de Telescope no dice por qué está vacío ni qué tecla usar);
--- si hay, abre el picker.
---@param method string
---@param extra? table campos extra de los params (p. ej. context)
---@param empty_hint string mensaje cuando no hay resultados (%s = símbolo)
---@param open fun()
local function lookup(method, extra, empty_hint, open)
  local client = vim.lsp.get_clients({ bufnr = 0, method = method })[1]
  local params = vim.tbl_extend("force", vim.lsp.util.make_position_params(0, client.offset_encoding), extra or {})
  local symbol = vim.fn.expand "<cword>"

  vim.lsp.buf_request_all(0, method, params, function(results)
    local count = 0
    for _, response in pairs(results) do
      local result = response.result
      if result then
        count = count + (vim.islist(result) and #result or 1)
      end
    end
    if count == 0 then
      log.info(empty_hint:format(symbol))
    else
      open()
    end
  end)
end

--- Dónde se usa el símbolo bajo el cursor: lista filtrable con vista previa;
--- Enter salta, <C-q> la manda a quickfix. No incluye la declaración.
function M.references()
  if not supported("textDocument/references", "find references") then
    return
  end
  local origin = nav.origin()
  lookup(
    "textDocument/references",
    { context = { includeDeclaration = false } },
    "'%s' is not used anywhere else",
    function()
      require("telescope.builtin").lsp_references(vim.tbl_extend("force", with_back(origin), { include_declaration = false }))
    end
  )
end

--- Ctrl+click: mueve el cursor al punto clicado y salta a la definición.
--- En ventanas que no son de código (nvim-tree, dashboard...) solo mueve el cursor.
function M.goto_definition_at_mouse()
  local pos = vim.fn.getmousepos()
  if pos.winid == 0 or pos.line == 0 then
    return
  end
  vim.api.nvim_set_current_win(pos.winid)
  pcall(vim.api.nvim_win_set_cursor, pos.winid, { pos.line, math.max(pos.column - 1, 0) })

  if vim.bo[vim.api.nvim_win_get_buf(pos.winid)].buftype == "" then
    M.goto_definition()
  end
end

return M
