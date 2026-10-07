-- ── Volver a la última posición al reabrir un archivo ────────────────────────
-- Usa la marca `"` (la guarda shada al cerrar el buffer). Se ignoran los commits y
-- los buffers que no son de archivo, y se comprueba que la línea aún exista.
local M = {}

local SKIP_FT = { "gitcommit", "gitrebase" }

function M.setup()
  vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("LastPosition", { clear = true }),
    callback = function(args)
      if vim.bo[args.buf].buftype ~= "" or vim.tbl_contains(SKIP_FT, vim.bo[args.buf].filetype) then
        return
      end
      local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
      if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })
end

return M
