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

-- Forzar cmdheight=0 tras carga completa (pisa cualquier plugin que lo reseteé)
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.o.cmdheight = 0
  end,
})

-- Arrancar el highlighter de treesitter: la rama "main" de nvim-treesitter
-- ya no lo hace sola (a diferencia de la vieja configs.setup{highlight=...}).
-- Sin esto ningún capture "@function"/"@operator"/etc. se resalta nunca,
-- aunque el parser esté instalado (queda solo la sintaxis regex de vim).
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
