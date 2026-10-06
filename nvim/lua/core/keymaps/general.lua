-- ── Keymaps generales (no dependen de lenguaje ni de plugins) ────────────────
local M = {}

-- <leader>q: cierra el buffer actual; si ya no queda ninguno de archivo, sale de nvim
-- (`confirm qa` pregunta si hay cambios sin guardar).
local function close_or_quit()
  local cur = vim.api.nvim_get_current_buf()

  -- ventanas especiales (nvim-tree, help, quickfix...): solo cierra la ventana
  if vim.bo[cur].buftype ~= "" and vim.bo[cur].filetype ~= "nvdash" then
    if #vim.api.nvim_tabpage_list_wins(0) > 1 and pcall(vim.cmd, "close") then
      return
    end
    return vim.cmd "confirm qa"
  end

  local files = vim.tbl_filter(function(b)
    return b.listed == 1 and vim.bo[b.bufnr].buftype == ""
  end, vim.fn.getbufinfo { buflisted = 1 })

  -- dashboard o último archivo: no hay nada más que cerrar
  if vim.bo[cur].filetype == "nvdash" or #files <= 1 then
    return vim.cmd "confirm qa"
  end

  require("nvchad.tabufline").close_buffer(cur)
end

function M.setup()
  local map = vim.keymap.set

  map("n", ";", ":", { desc = "CMD enter command mode" })
  map("i", "jk", "<ESC>")
  map("n", "<leader>w", "<cmd>w<CR>", { desc = "save" })
  map("n", "<leader>q", close_or_quit, { desc = "close buffer / quit" })

  -- CTRL+click → ir a definición (LSP); <C-o> vuelve atrás, <C-i> adelante
  map(
    "n",
    "<C-LeftMouse>",
    require("utils.lsp").goto_definition_at_mouse,
    { desc = "ir a donde se DEFINE (Ctrl+click)" }
  )
end

return M
