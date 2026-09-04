require "nvchad.mappings"

-- ── Disable NvChad keymaps we don't use ──────────────────────────────────────
local map = vim.keymap.set
map("n", "<leader>h", "<Nop>", { desc = "disabled" })
map("n", "<leader>v", "<Nop>", { desc = "disabled" })
map("n", "<leader>pt", "<Nop>", { desc = "disabled" })
map("n", "<leader>fa", "<Nop>", { desc = "disabled" })
map("n", "<leader>fz", "<Nop>", { desc = "disabled" })
map("n", "<leader>ma", "<Nop>", { desc = "disabled" })
map("n", "<leader>cm", "<Nop>", { desc = "disabled" })
map("n", "<leader>fh", "<Nop>", { desc = "disabled" })
map("n", "<leader>rn", "<Nop>", { desc = "disabled" })
map("n", "<leader>n", "<Nop>", { desc = "disabled" })
map("n", "<leader>th", "<Nop>", { desc = "disabled" })
map("n", "<leader>ch", "<Nop>", { desc = "disabled" })
map("n", "<leader>wK", "<Nop>", { desc = "disabled" })
map("n", "<leader>wk", "<Nop>", { desc = "disabled" })
map("n", "<leader>xb", "<Nop>", { desc = "disabled" })
map("n", "<leader>oa", "<Nop>", { desc = "disabled" })
map("n", "<leader>oA", "<Nop>", { desc = "disabled" })
map("n", "<leader>fc", "<Nop>", { desc = "disabled" })
map("n", "<leader>gb", "<Nop>", { desc = "disabled" })
map("n", "<leader>gd", "<Nop>", { desc = "disabled" })
map("n", "<leader>ds", "<Nop>", { desc = "disabled" })
map("n", "<leader>qs", "<Nop>", { desc = "disabled" })
map("n", "<leader>qS", "<Nop>", { desc = "disabled" })
map("n", "<leader>qd", "<Nop>", { desc = "disabled" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>w", "<cmd>w<CR>", { desc = "save" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- CTRL+click → ir a definición (LSP)
map("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })

-- ── Go: run/build/vet/format/tidy/fix/test en terminal flotante ──────────
-- Keymaps globales (no buffer-local vía FileType autocmd: NvChad carga este
-- archivo con vim.schedule, así que un autocmd FileType se pierde el evento
-- del buffer inicial al abrir "nvim main.go" directo). Cada acción valida el
-- filetype al ejecutarse. run/build corren sobre el DIRECTORIO del archivo
-- actual (un paquete Go es por carpeta, no por módulo): "." si esa carpeta
-- cuelga de un go.mod (recoge todos los .go hermanos), o el archivo suelto
-- si no hay módulo (script rápido). vet corren "./..." desde la raíz
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
end, { desc = "run" })

map("n", "<leader>rb", function()
  if not go_buffer() then
    return
  end
  local file_dir, mod_root = go_paths()
  local target = mod_root and "." or vim.fn.shellescape(vim.fn.expand "%:t")
  go_float("go build " .. target, file_dir)
end, { desc = "build" })

map("n", "<leader>rv", function()
  if not go_buffer() then
    return
  end
  local file_dir, mod_root = go_paths()
  local cmd = vim.fn.executable "golangci-lint" == 1 and "golangci-lint run ./..." or "go vet ./..."
  go_float(cmd, mod_root or file_dir)
end, { desc = "vet" })

map("n", "<leader>rf", function()
  if not go_buffer() then
    return
  end
  require("conform").format { lsp_fallback = true }
end, { desc = "format" })

map("n", "<leader>rt", function()
  if not go_buffer() then
    return
  end
  local _, mod_root = go_paths()
  if not mod_root then
    vim.notify("No hay go.mod en el proyecto", vim.log.levels.WARN)
    return
  end
  go_float("go mod tidy", mod_root)
end, { desc = "tidy" })

map("n", "<leader>rx", function()
  if not go_buffer() then
    return
  end
  local file_dir, mod_root = go_paths()
  go_float("golangci-lint run --fix ./...", mod_root or file_dir)
end, { desc = "fix" })

map("n", "<leader>rm", function()
  if not go_buffer() then
    return
  end
  local file_dir, mod_root = go_paths()
  go_float("go test ./...", mod_root or file_dir)
end, { desc = "test" })
