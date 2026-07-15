require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- CTRL+click → ir a definición (LSP)
map("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })

-- ── Go: run/build/vet/fix/format en terminal flotante ──────────────────────
-- Keymaps globales (no buffer-local vía FileType autocmd: NvChad carga este
-- archivo con vim.schedule, así que un autocmd FileType se pierde el evento
-- del buffer inicial al abrir "nvim main.go" directo). Cada acción valida el
-- filetype al ejecutarse. run/build corren sobre el DIRECTORIO del archivo
-- actual (un paquete Go es por carpeta, no por módulo): "." si esa carpeta
-- cuelga de un go.mod (recoge todos los .go hermanos), o el archivo suelto
-- si no hay módulo (script rápido). vet/fix corren "./..." desde la raíz
-- del módulo para cubrir todo el proyecto.
local function go_buffer()
  if vim.bo.filetype ~= "go" then
    vim.notify("No es un buffer de Go", vim.log.levels.WARN)
    return false
  end
  return true
end

local function go_paths()
  local file_dir = vim.fn.expand "%:p:h"
  local gomod = vim.fs.find("go.mod", { path = file_dir, upward = true })[1]
  return file_dir, gomod and vim.fs.dirname(gomod)
end

local function go_float(cmd, dir)
  vim.cmd(("TermExec cmd=%s dir=%s direction=float"):format(vim.fn.shellescape(cmd), vim.fn.shellescape(dir)))
end

map("n", "<leader>rr", function()
  if not go_buffer() then
    return
  end
  local file_dir, mod_root = go_paths()
  local target = mod_root and "." or vim.fn.shellescape(vim.fn.expand "%:t")
  go_float("go run " .. target, file_dir)
end, { desc = "Go run" })

map("n", "<leader>rb", function()
  if not go_buffer() then
    return
  end
  local file_dir, mod_root = go_paths()
  local target = mod_root and "." or vim.fn.shellescape(vim.fn.expand "%:t")
  go_float("go build " .. target, file_dir)
end, { desc = "Go build" })

map("n", "<leader>rv", function()
  if not go_buffer() then
    return
  end
  local file_dir, mod_root = go_paths()
  local cmd = vim.fn.executable "golangci-lint" == 1 and "golangci-lint run ./..." or "go vet ./..."
  go_float(cmd, mod_root or file_dir)
end, { desc = "Go vet/lint (revisor)" })

map("n", "<leader>rx", function()
  if not go_buffer() then
    return
  end
  local file_dir, mod_root = go_paths()
  go_float("golangci-lint run --fix ./...", mod_root or file_dir)
end, { desc = "Go lint --fix" })

map("n", "<leader>rf", function()
  if not go_buffer() then
    return
  end
  require("conform").format { lsp_fallback = true }
end, { desc = "Go format (gofumpt/goimports)" })

-- Doc offline ("go doc" local, sin red, floating window).
-- No usamos :GoDoc de go.nvim: solo pasa <cword> (ej. "Println" en vez de
-- "fmt.Println"), lo que casi siempre falla para simbolos de paquetes
-- externos, y su jobstart no reporta el error (queda en silencio total).
-- Aqui reconstruimos "paquete.Simbolo" mirando la linea alrededor del
-- cursor, y mostramos un aviso si "go doc" falla.
local function go_doc_query()
  local cword = vim.fn.expand "<cword>"
  if cword == "" then
    return nil
  end
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local start_idx = col + 1
  while start_idx > 1 and line:sub(start_idx - 1, start_idx - 1):match "[%w_]" do
    start_idx = start_idx - 1
  end
  if start_idx > 1 and line:sub(start_idx - 1, start_idx - 1) == "." then
    local pkg_end = start_idx - 2
    local pkg_start = pkg_end
    while pkg_start > 0 and line:sub(pkg_start, pkg_start):match "[%w_]" do
      pkg_start = pkg_start - 1
    end
    pkg_start = pkg_start + 1
    if pkg_end >= pkg_start then
      local pkg = line:sub(pkg_start, pkg_end)
      if pkg:match "^%l[%w_]*$" then
        return pkg .. "." .. cword
      end
    end
  end
  return cword
end

-- Replica el resaltado de go.nvim: lineas con indentacion 0 (firmas) u
-- 8-multiplo dentro de un bloque son codigo; el resto es prosa.
local function go_doc_format(lines)
  local out = {}
  local in_code = false
  for _, line in ipairs(lines) do
    local leading = line:match "^%s*"
    local is_code = #leading == 0 or (#leading % 8 == 0 and in_code)
    if is_code and not in_code then
      table.insert(out, "```go")
      in_code = true
    elseif not is_code and in_code then
      table.insert(out, "```")
      in_code = false
    end
    table.insert(out, line)
  end
  if in_code then
    table.insert(out, "```")
  end
  return out
end

-- "go doc" solo indexa paquetes y declaraciones a nivel de paquete
-- (funciones/tipos/vars/consts); las no exportadas requieren "-u", y
-- variables locales/parametros/keywords no existen para "go doc" en
-- absoluto. Por eso reintentamos con "-u" y, si aun asi no hay nada,
-- caemos a gopls hover (tambien 100% local, sin red) para lo demas.
local function run_go_doc(args, cwd, callback)
  local stdout, stderr = {}, {}
  vim.fn.jobstart(vim.list_extend({ "go", "doc" }, args), {
    cwd = cwd,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      stdout = data
    end,
    on_stderr = function(_, data)
      stderr = data
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        local out_lines = vim.tbl_filter(function(l)
          return l ~= ""
        end, stdout)
        if code ~= 0 or #out_lines == 0 then
          callback(false, table.concat(
            vim.tbl_filter(function(l)
              return l ~= ""
            end, stderr),
            " "
          ))
        else
          callback(true, stdout)
        end
      end)
    end,
  })
end

map("n", "<leader>rd", function()
  if not go_buffer() then
    return
  end
  local query = go_doc_query()
  if not query then
    vim.notify("Coloca el cursor sobre un simbolo de Go", vim.log.levels.WARN)
    return
  end
  local cwd = vim.fn.expand "%:p:h"

  local function show(lines)
    vim.lsp.util.open_floating_preview(go_doc_format(lines), "markdown", {
      border = "rounded",
      focusable = true,
      close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre" },
      max_width = math.floor(vim.o.columns * 0.8),
      max_height = math.floor(vim.o.lines * 0.8),
    })
  end

  run_go_doc({ query }, cwd, function(ok, result)
    if ok then
      show(result)
      return
    end
    run_go_doc({ "-u", query }, cwd, function(ok_u, result_u)
      if ok_u then
        show(result_u)
        return
      end
      local clients = vim.lsp.get_clients { bufnr = 0, name = "gopls" }
      if #clients > 0 then
        vim.lsp.buf.hover()
      else
        vim.notify("go doc " .. query .. ": " .. (result_u ~= "" and result_u or "sin resultados"), vim.log.levels.WARN)
      end
    end)
  end)
end, { desc = "Go doc offline (cursor word)" })
