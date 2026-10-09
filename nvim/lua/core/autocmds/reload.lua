-- ── Auto-recarga de la config tras `git pull` ────────────────────────────────
-- El hook .githooks/post-merge crea un marcador en stdpath("data"); al entrar a
-- la UI se recarga init.lua y se borra el marcador.
local M = {}

function M.setup()
  local marker = vim.fn.stdpath "data" .. "/.config-reloaded"

  vim.api.nvim_create_autocmd("UIEnter", {
    group = vim.api.nvim_create_augroup("ConfigAutoReload", { clear = true }),
    once = true,
    callback = function()
      if vim.fn.filereadable(marker) ~= 1 then
        return
      end
      vim.cmd "silent! luafile $MYVIMRC"
      vim.fn.delete(marker)
      vim.notify "Config reloaded automatically after git pull"
    end,
  })
end

return M
