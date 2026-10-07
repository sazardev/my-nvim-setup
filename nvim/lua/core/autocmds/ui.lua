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

  -- El dashboard (nvdash) se redibuja al redimensionar poniendo `modifiable = true` y
  -- nunca lo vuelve a bloquear (bug de NvChad): se podía escribir texto en él. Se
  -- re-bloquea justo después de su redibujado.
  vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
    group = vim.api.nvim_create_augroup("RelockNvdash", { clear = true }),
    callback = function()
      vim.schedule(function()
        local buf = vim.g.nvdash_buf
        if buf and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "nvdash" then
          vim.bo[buf].modifiable = false
        end
      end)
    end,
  })
end

return M
