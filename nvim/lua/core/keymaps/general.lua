-- ── Keymaps generales (no dependen de lenguaje ni de plugins) ────────────────
local M = {}

function M.setup()
  local map = vim.keymap.set

  map("n", ";", ":", { desc = "CMD enter command mode" })
  map("i", "jk", "<ESC>")
  map("n", "<leader>w", "<cmd>w<CR>", { desc = "save" })

  -- CTRL+click → ir a definición (LSP)
  map("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
end

return M
