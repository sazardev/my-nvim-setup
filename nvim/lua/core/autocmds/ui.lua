-- ── Ajustes de UI que algún plugin podría pisar ──────────────────────────────
local M = {}

function M.setup()
  -- Forzar cmdheight=0 tras la carga completa (pisa cualquier plugin que lo resetee)
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("ForceCmdheight", { clear = true }),
    once = true,
    callback = function()
      vim.o.cmdheight = 0
    end,
  })
end

return M
