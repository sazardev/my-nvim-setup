require "nvchad.options"

local o = vim.o

-- Carga .nvim.lua en la raíz de cada proyecto (config por repositorio)
o.exrc = true

-- Quitar espacio muerto al fondo (refuerzo de cmdheight + showmode/showcmd)
o.cmdheight = 0
o.showmode = false
o.showcmd = false

-- ── Performance: "rayo" ──────────────────────────────────────────────────────
o.lazyredraw    = true   -- no redibujar durante macros/..
o.synmaxcol     = 200    -- corta highlight de líneas larguísimas
o.updatetime    = 250    -- cursorhold más sensible
o.more          = false  -- sin "--More--" (usa <C-d>)
o.pumblend      = 0      -- sin transparencia en popup menu
o.winblend      = 0      -- sin transparencia en ventanas
o.redrawtime    = 1500
o.confirm       = true   -- confirm al :q con buffer modificado

-- ── Visibilidad de código ─────────────────────────────────────────────────────
o.cursorline    = true   -- sutil, ayuda en gruvbox
o.cursorlineopt = "both" -- número + línea (no screenline, más rápido)

-- ── Sign column: solo aparece si hay un sign (todo-comments) ─────────────────
o.signcolumn = "auto:1"

-- maplocalleader = space (importante para LSP de buffer-local mappings)
vim.g.maplocalleader = " "
