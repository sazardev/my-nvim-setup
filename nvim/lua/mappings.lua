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

-- Doc offline (go.nvim ya trae :GoDoc, corre "go doc" local, sin red):
-- documentación de la palabra bajo el cursor en floating window.
map("n", "<leader>rd", function()
  if not go_buffer() then
    return
  end
  vim.cmd("GoDoc " .. vim.fn.expand "<cword>")
end, { desc = "Go doc offline (cursor word)" })
