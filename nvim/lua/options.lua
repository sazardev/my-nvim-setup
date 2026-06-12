require "nvchad.options"

local o = vim.o

-- Carga .nvim.lua en la raíz de cada proyecto (config por repositorio)
o.exrc = true

-- Quitar espacio muerto al fondo (refuerzo de cmdheight + showmode/showcmd)
o.cmdheight = 0
o.showmode = false
o.showcmd = false

-- o.cursorlineopt ='both' -- to enable cursorline!
