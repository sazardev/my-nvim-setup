-- Punto de entrada mínimo: la lógica vive en lua/core/.
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
vim.o.cmdheight = 0

-- bytecode cache de módulos Lua (startup más rápido)
vim.loader.enable()

require("core.lazy").setup()
require("core").setup()
