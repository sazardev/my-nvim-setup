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
o.updatetime    = 350    -- 250 era agresivo (idle CPU)
o.more          = false  -- sin "--More--" (usa <C-d>)
o.pumblend      = 0      -- sin transparencia en popup menu
o.winblend      = 0      -- sin transparencia en ventanas
o.redrawtime    = 1500
o.confirm       = true   -- confirm al :q con buffer modificado

-- ── Snappier leader/terminal ──────────────────────────────────────────────────
o.timeoutlen    = 300    -- antes 1000 (default)
o.ttimeoutlen   = 50     -- escape de terminal casi instantáneo

-- ── Splits donde esperás ─────────────────────────────────────────────────────
o.splitright    = true
o.splitbelow    = true

-- ── Cursor con aire ──────────────────────────────────────────────────────────
o.scrolloff     = 5
o.sidescrolloff = 8

-- ── globalstatus para lualine ─────────────────────────────────────────────────
o.laststatus    = 3

-- ── Mensajes discretos ───────────────────────────────────────────────────────
vim.opt.shortmess:append("c")   -- silencia "1 line yanked" etc.

-- ── Flotantes limpios (sin bordes chillones) ─────────────────────────────────
o.winhighlight = "NormalFloat:Normal,FloatBorder:Comment,FloatTitle:Comment"

-- ── Visibilidad de código ─────────────────────────────────────────────────────
o.cursorline    = true   -- sutil, ayuda en gruvbox
o.cursorlineopt = "number" -- colorea solo el nº, menos redraw

-- ── Sign column: solo aparece si hay un sign (todo-comments) ─────────────────
o.signcolumn = "auto:1"

-- maplocalleader = space (importante para LSP de buffer-local mappings)
vim.g.maplocalleader = " "
