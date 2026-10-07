-- ── Recargar archivos cambiados fuera de nvim ────────────────────────────────
-- `autoread` solo actúa cuando se llama a :checktime; nvim no lo hace al volver el
-- foco en una terminal. Así lo que cambian git, formatters o otro editor se recarga
-- solo (los buffers con cambios sin guardar nunca se pisan: nvim pregunta).
local M = {}

function M.setup()
  vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = vim.api.nvim_create_augroup("AutoRead", { clear = true }),
    callback = function()
      -- en la línea de comandos checktime daría error
      if vim.o.autoread and vim.fn.getcmdwintype() == "" then
        vim.cmd.checktime()
      end
    end,
  })
end

return M
