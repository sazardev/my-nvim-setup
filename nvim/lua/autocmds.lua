require "nvchad.autocmds"

-- Auto-recargar config tras git pull (detecta marcador del post-merge hook)
local marker = vim.fn.stdpath "data" .. "/.config-reloaded"
vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    if vim.fn.filereadable(marker) == 1 then
      vim.cmd "silent! luafile $MYVIMRC"
      vim.fn.delete(marker)
      vim.notify "Config recargada automáticamente tras git pull"
    end
  end,
})
