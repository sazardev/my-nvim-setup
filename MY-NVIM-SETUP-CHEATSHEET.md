# 🧠 MY-NVIM-SETUP — Cheatsheet Completo

> Generado leyendo el código real de este repo (`nvim/lua/mappings.lua`, `chadrc.lua`, `plugins/init.lua`, `configs/*.lua`) y de los plugins instalados en `~/.local/share/nvim/lazy/*` (NvChad core, nvim-tree, telescope, gitsigns, etc). No es de memoria: cada atajo listado existe en el config o en el default real del plugin.
>
> **`<leader>` = `<Space>`** · **`<localleader>` = `<Space>`**

## Leyenda

| Marca | Significa |
|---|---|
| `[C]` | Definido/custom en **este repo** |
| `[NvChad]` | Viene de `nvchad.mappings` / `nvchad.configs.lspconfig` (no está en este repo, pero se carga con `require "nvchad.mappings"`) |
| `[Plugin]` | Default del plugin, sin remapear |
| `[Nvim]` | Nativo de Neovim/Vim, no depende de ningún plugin |

## 0. Datos clave de este setup (no asumir defaults genéricos de NvChad/Vim)

- **Tabufline DESHABILITADA** (`chadrc.lua` → `ui.tabufline.enabled = false`). Esto significa que **`<Tab>`, `<S-Tab>`, `<leader>b`, `<leader>x` NO están mapeados** (son parte del bloque `if tabufline.enabled` en `nvchad.mappings` y se saltea). Para moverte entre buffers usá `<leader>fb` (Telescope) o los comandos nativos `:bnext`/`:bprevious` (§3.8).
- **Statusline NvChad deshabilitada** → reemplazada por `lualine.nvim` (visual únicamente, sin keymaps).
- `exrc = true` → cada proyecto puede tener su propio `.nvim.lua` en la raíz que se carga automáticamente.
- `cmdheight = 0`, `signcolumn = "auto:1"` → UI minimalista, sin espacio muerto.
- `timeoutlen = 300` → tenés 300ms para completar una secuencia de teclas tipo `<leader>ff` antes de que se cancele.
- **gitsigns no tiene `on_attach` configurado** → los signs (+/-/~) y `numhl` funcionan, pero **no hay keymaps de hunks** (stage/preview/next/prev hunk). Se listan en §2.7 como comandos `:Gitsigns <acción>` por si querés bindearlos vos mismo en `mappings.lua`.
- Requiere **Neovim ≥ 0.11** (usa `vim.lsp.enable`/`vim.lsp.config`), por lo que los keymaps LSP **nativos de Neovim 0.11** (`grn`, `gra`, `grr`, `gri`, `gO`) están activos además de los de NvChad — ver §2.6.

---

## 1. Árbol completo de `<leader>` (mapa mental)

```
<leader>
├─ b            [omitido: tabufline off]         buffer nuevo
├─ x            [omitido: tabufline off]         cerrar buffer
├─ n            [NvChad] toggle número de línea
├─ rn           [NvChad] toggle número relativo
├─ ch           [NvChad] abrir NvCheatsheet
├─ fm    (n,x)  [NvChad] formatear archivo (conform + lsp fallback)
├─ ds           [NvChad] diagnósticos → loclist
├─ /     (n,v)  [NvChad] toggle comentario (gcc / gc)
├─ D            [NvChad] LSP: ir a definición de tipo
├─ ra           [NvChad] LSP: renombrar símbolo (NvRenamer)
├─ e            [NvChad] enfocar nvim-tree
│
├─ f  (find — Telescope)
│  ├─ f         find_files
│  ├─ a         find_files (todos, incluso ignorados/ocultos)
│  ├─ w         live_grep (buscar texto en todo el proyecto)
│  ├─ b         buffers abiertos
│  ├─ o         oldfiles (archivos recientes)
│  ├─ z         fuzzy find dentro del buffer actual
│  ├─ h         help_tags
│  └─ c         [C] clipboard history (neoclip)
│
├─ g  (git)
│  ├─ g         [C] LazyGit
│  ├─ d         [C] lazydocker
│  ├─ b         [C] toggle git-blame inline
│  └─ t         [NvChad] Telescope git_status
│
├─ w  (workspace / which-key)
│  ├─ a         LSP: agregar workspace folder
│  ├─ r         LSP: quitar workspace folder
│  ├─ l         LSP: listar workspace folders
│  ├─ K         which-key: mostrar todos los keymaps
│  └─ k         which-key: consulta puntual
│
├─ t  (test / terminal / tasks — mezclado por plugin)
│  ├─ t         [C] toggle terminal flotante (toggleterm)
│  ├─ n         [C] neotest: correr test más cercano
│  ├─ f         [C] neotest: correr archivo de test
│  ├─ s         [C] neotest: correr suite completa
│  ├─ l         [C] neotest: correr último test
│  ├─ o         [C] neotest: ver output del test
│  ├─ X         [C] neotest: detener tests
│  └─ w         [C] neotest: toggle panel resumen
│
├─ o  (outline / overseer)
│  ├─ r         [C] overseer: correr tarea
│  ├─ t         [C] overseer: toggle lista de tareas
│  ├─ w         [C] overseer: watch output de tarea
│  ├─ a         [C] aerial: toggle outline de símbolos
│  └─ A         [C] aerial: toggle nav window
│
├─ x  (diagnósticos — Trouble)
│  ├─ x         [C] Trouble: diagnósticos (todo el proyecto)
│  └─ b         [C] Trouble: diagnósticos del buffer actual
│
├─ r  (run — Go, global pero solo actúa en buffers filetype=go)
│  ├─ r         [C] go run (terminal flotante; detecta módulo vs script suelto)
│  ├─ b         [C] go build (mismo detector de módulo)
│  ├─ v         [C] revisor: golangci-lint run ./... (o go vet si falta)
│  ├─ x         [C] golangci-lint run --fix ./...
│  ├─ f         [C] format explícito (conform: gofumpt + goimports)
│  └─ d         [C] go doc offline de la palabra bajo el cursor (:GoDoc, go.nvim)
│
├─ d             u   [C] toggle DAP UI (debugger)
│
├─ h  (harpoon)
│  ├─ a         [C] agregar archivo actual a harpoon
│  └─ m         [C] abrir menú harpoon
│
├─ q  (sesiones — persistence.nvim)
│  ├─ s         [C] restaurar última sesión  ⚠️ ver nota abajo
│  ├─ S         [C] guardar sesión actual
│  └─ d         [C] no guardar sesión al salir
│
├─ p  t          [NvChad] Telescope: elegir terminal oculta
├─ c  m          [NvChad] Telescope git_commits
├─ m  a          [NvChad] Telescope marks
├─ t  h          [NvChad] Telescope: elegir tema NvChad
└─ v / h (sin prefijo de letra doble)
   ├─ h         [NvChad] nueva terminal horizontal
   └─ v         [NvChad] nueva terminal vertical
```

> ⚠️ **`<leader>qs` tiene dos significados según el modo**: en modo **Normal** restaura la sesión (persistence.nvim); en modo **Visual** ordena la selección (`sort.nvim` → `:Sort`). No es un conflicto real (which-key resuelve por modo), pero es fácil de olvidar.

### Teclas fuera del `<leader>` (Ctrl / Alt / especiales)

```
<C-s>            [NvChad] guardar archivo
<C-c>            [NvChad] copiar archivo completo al clipboard (+)
<C-n>            [NvChad] toggle nvim-tree
<C-h/j/k/l>      [NvChad] moverse entre ventanas/splits
<C-LeftMouse>    [C] Ctrl+click → ir a definición LSP
<A-1..4>         [C] harpoon: saltar a archivo marcado 1–4
<A-v>            [NvChad] toggle terminal vertical
<A-h>            [NvChad] toggle terminal horizontal
<A-i>            [NvChad] toggle terminal flotante
<Esc>            [NvChad] limpiar resaltado de búsqueda (:noh)
s   (n,x,o)      [C] Flash: saltar a cualquier palabra visible
S   (n,x,o)      [C] Flash: saltar por nodo de treesitter (función/clase)
;                [C] entra a modo comando (equivale a :)
jk    (insert)   [C] Escape
```

---

## 2. Detalle por categoría

### 2.1 Edición básica / general `[NvChad]` `[C]`

| Tecla | Modo | Acción |
|---|---|---|
| `<C-s>` | n | Guardar archivo |
| `<C-c>` | n | Copiar **todo el archivo** al registro `+` (clipboard sistema) |
| `<Esc>` | n | Quitar resaltado de búsqueda (`:noh`) |
| `<leader>n` | n | Toggle números de línea |
| `<leader>rn` | n | Toggle números relativos |
| `<leader>fm` | n, x | Formatear archivo (conform.nvim, fallback a LSP) |
| `<leader>/` | n | Comentar/descomentar línea (`gcc`) |
| `<leader>/` | v | Comentar/descomentar selección (`gc`) |
| `;` | n | `[C]` Entra a modo comando (como `:` pero sin `Shift`) |
| `jk` | i | `[C]` Salir a modo Normal |
| `<C-LeftMouse>` | n | `[C]` Ctrl+Click → ir a definición LSP |

### 2.2 Ventanas / splits `[NvChad]`

| Tecla | Acción |
|---|---|
| `<C-h>` | Ir a la ventana de la izquierda |
| `<C-l>` | Ir a la ventana de la derecha |
| `<C-j>` | Ir a la ventana de abajo |
| `<C-k>` | Ir a la ventana de arriba |

Splits nuevos siempre abren a la derecha/abajo (`splitright`/`splitbelow` en `options.lua`).

### 2.3 Buffers (⚠️ tabufline deshabilitada)

Este repo **desactiva** la tabufline de NvChad, así que **no hay** `<Tab>`/`<S-Tab>`/`<leader>b`/`<leader>x`. Alternativas reales que sí funcionan:

| Acción | Cómo |
|---|---|
| Listar/buscar buffers abiertos | `<leader>fb` (Telescope) |
| Siguiente / anterior buffer | `:bnext` / `:bprevious` (nativo, ver §3.8) |
| Cerrar buffer actual | `:bd` (nativo) |
| Buffer nuevo vacío | `:enew` (nativo) |

### 2.4 Explorador de archivos — nvim-tree `[Plugin default]` + `[C]` override

Se abre con `<C-n>` (toggle) o `<leader>e` (focus). Dentro del árbol (`on_attach_default` de nvim-tree, sin remapear salvo `<CR>`):

**Navegación**
| Tecla | Acción |
|---|---|
| `<CR>` / `o` | `[C]` Abrir archivo **y cerrar el árbol** (override de este repo; en carpetas solo expande) |
| `<2-LeftMouse>` | Abrir (doble click) |
| `<Tab>` | Preview del archivo sin salir del árbol |
| `<BS>` | Cerrar directorio (subir un nivel visualmente) |
| `-` | Subir el root del árbol al padre |
| `<C-]>` / `<2-RightMouse>` | `cd` — cambiar root al nodo bajo el cursor |
| `P` | Ir al directorio padre |
| `K` / `J` | Ir al primer / último hermano (sibling) |
| `<` / `>` | Hermano anterior / siguiente |
| `E` / `W` | Expandir todo / colapsar todo |
| `]c` / `[c` | Siguiente / anterior archivo con cambios git |
| `]e` / `[e` | Siguiente / anterior diagnóstico LSP |

**Archivos / carpetas**
| Tecla | Acción |
|---|---|
| `a` | Crear archivo o carpeta (terminá el nombre en `/` para carpeta) |
| `d` / `<Del>` | Eliminar |
| `D` | Mover a la papelera (trash) |
| `r` | Renombrar |
| `e` | Renombrar solo el basename (mantiene extensión seleccionable) |
| `u` | Renombrar path completo |
| `<C-r>` | Renombrar omitiendo el filename |
| `x` | Cortar |
| `c` | Copiar |
| `p` | Pegar |
| `gp` | Mover (paste como move) |
| `y` | Copiar nombre |
| `Y` | Copiar path relativo |
| `gy` | Copiar path absoluto |
| `<C-v>` | Abrir en vertical split |
| `<C-x>` | Abrir en horizontal split |
| `<C-t>` | Abrir en tab nueva |
| `<C-e>` | Abrir reemplazando el buffer del árbol |

**Filtros / bookmarks / varios**
| Tecla | Acción |
|---|---|
| `H` | Toggle dotfiles |
| `I` | Toggle archivos git-ignored (por defecto ocultos en este repo) |
| `B` | Toggle filtro "no buffer" |
| `C` | Toggle filtro git clean |
| `U` | Toggle filtro custom |
| `f` | Live filter: empezar a escribir para filtrar |
| `F` | Live filter: limpiar |
| `m` | Toggle bookmark en el nodo |
| `bd` / `bt` / `bmv` | Eliminar / mover a papelera / mover en bloque los bookmarked |
| `M` | Toggle filtro "sin bookmark" |
| `s` | Ejecutar con el sistema (abrir con app externa) |
| `.` | Ejecutar comando sobre el nodo |
| `S` | Buscar nodo por nombre |
| `R` | Refrescar árbol |
| `<C-k>` | Popup con info del archivo |
| `q` | Cerrar árbol |
| `g?` | Ayuda (lista todos los keymaps in-app) |

### 2.5 Búsqueda difusa — Telescope `[NvChad]`

| Tecla | Acción |
|---|---|
| `<leader>ff` | Buscar archivos (respeta `.gitignore`, ignora `node_modules`, `dist`, `.next`, etc.) |
| `<leader>fa` | Buscar **todos** los archivos (incluye ignorados y ocultos) |
| `<leader>fw` | `live_grep` — buscar texto en todo el proyecto (ripgrep) |
| `<leader>fz` | Fuzzy find dentro del buffer actual |
| `<leader>fb` | Buffers abiertos |
| `<leader>fo` | Archivos recientes (oldfiles) |
| `<leader>fh` | Buscar en el help de Neovim |
| `<leader>fc` | `[C]` Historial de clipboard (neoclip) |
| `<leader>ma` | Marks |
| `<leader>cm` | Git commits |
| `<leader>gt` | Git status (archivos modificados) |
| `<leader>pt` | Elegir entre terminales ocultas |
| `<leader>th` | Selector de tema NvChad (`gruvbox` ⇄ `gruvbox_light`) |

**Dentro del picker** (defaults de Telescope, modo insert):

| Tecla | Acción |
|---|---|
| `<C-n>` / `<Down>` | Resultado siguiente |
| `<C-p>` / `<Up>` | Resultado anterior |
| `<CR>` | Abrir selección |
| `<C-x>` | Abrir en split horizontal |
| `<C-v>` | Abrir en split vertical |
| `<C-t>` | Abrir en tab nueva |
| `<Tab>` | Multi-selección: marcar y bajar |
| `<S-Tab>` | Multi-selección: marcar y subir |
| `<C-q>` | Enviar resultados a la quickfix list y abrirla |
| `<M-q>` | Enviar **todos** los resultados a quickfix |
| `<C-u>` / `<C-d>` | Scroll arriba/abajo en el preview |
| `<C-c>` / `<Esc><Esc>` | Cerrar picker |

Presionando `<Esc>` una vez entrás al **modo Normal dentro del prompt**: ahí `j`/`k`/`gg`/`G` navegan como en cualquier buffer, y `q` cierra.

### 2.6 LSP — Neovim 0.11 nativo `[Nvim]` + NvChad `[NvChad]` + custom `[C]`

Como el config usa `vim.lsp.enable`/`vim.lsp.config` (API de Neovim ≥0.11), **también** están activos los keymaps LSP por defecto que trae Neovim 0.11 (`:h lsp-defaults`), además de los que agrega NvChad en `on_attach`.

| Tecla | Modo | Origen | Acción |
|---|---|---|---|
| `gd` | n | `[NvChad]` (pisa el default `grr`-style de nvim) | Ir a definición |
| `gD` | n | `[NvChad]` | Ir a declaración |
| `<leader>D` | n | `[NvChad]` | Ir a definición de **tipo** |
| `<leader>ra` | n | `[NvChad]` | Renombrar símbolo (UI: NvRenamer) |
| `<leader>wa` | n | `[NvChad]` | Agregar workspace folder |
| `<leader>wr` | n | `[NvChad]` | Quitar workspace folder |
| `<leader>wl` | n | `[NvChad]` | Listar workspace folders (imprime en `:messages`) |
| `<leader>ds` | n | `[NvChad]` | Diagnósticos del buffer → loclist |
| `grn` | n | `[Nvim]` | Renombrar símbolo (equivalente nativo a `<leader>ra`) |
| `gra` | n, v | `[Nvim]` | Code action |
| `grr` | n | `[Nvim]` | Referencias del símbolo |
| `gri` | n | `[Nvim]` | Ir a implementación |
| `gO` | n | `[Nvim]` | Listar símbolos del documento (outline rápido; ver también `<leader>oa` de aerial) |
| `gq` | operador | `[Nvim]` | Formatear con `formatexpr` provisto por el LSP |
| `K` | n | `[Nvim]` | Hover — documentación flotante del símbolo |
| `<C-s>` | i, s | `[Nvim]` | Signature help (ayuda de parámetros de función) |
| `<C-LeftMouse>` | n | `[C]` | Ctrl+Click → ir a definición |

Servidores activos: `gopls`, `vtsls` (TS/JS/React), `tailwindcss`, `eslint`, `jsonls` (+SchemaStore), `prismals`, `dockerls`, `docker_compose_language_service`, `astro`, `html`, `cssls`, `emmet_ls`, `lua_ls`.

### 2.7 Git — LazyGit / git-blame / gitsigns / Telescope `[C]` `[Plugin]`

| Tecla | Acción |
|---|---|
| `<leader>gg` | `[C]` Abrir LazyGit (TUI completo: stage, commit, push, branches, rebase interactivo, etc.) |
| `<leader>gd` | `[C]` Abrir lazydocker |
| `<leader>gb` | `[C]` Toggle git-blame inline (**apagado por defecto**, se activa/desactiva por rendimiento) |
| `<leader>gt` | `[NvChad]` Telescope: archivos con cambios git |
| `<leader>cm` | `[NvChad]` Telescope: log de commits |

**gitsigns** está activo (signos `+`/`~`/`-` en el gutter cuando hay `signcolumn`, y `numhl` colorea el número de línea) pero **sin keymaps configurados**. Podés ejecutar estas acciones manualmente con `:Gitsigns <acción>` o agregarles tecla vos mismo en `mappings.lua`:

| Comando | Qué hace |
|---|---|
| `:Gitsigns stage_hunk` | Stage del hunk bajo el cursor |
| `:Gitsigns undo_stage_hunk` | Deshacer el último stage |
| `:Gitsigns reset_hunk` | Descartar cambios del hunk |
| `:Gitsigns reset_buffer` | Descartar todos los cambios del buffer |
| `:Gitsigns preview_hunk` | Ver diff del hunk en flotante |
| `:Gitsigns blame_line` | Blame de la línea actual en flotante |
| `:Gitsigns toggle_current_line_blame` | Blame virtual inline (alternativa a `<leader>gb`) |
| `:Gitsigns diffthis` | Diff del buffer contra el índice |
| `:Gitsigns next_hunk` / `prev_hunk` | Saltar entre hunks modificados |
| `:Gitsigns select_hunk` | Seleccionar el hunk en modo visual |

### 2.8 Terminal `[NvChad]`

| Tecla | Acción |
|---|---|
| `<leader>h` | Nueva terminal horizontal |
| `<leader>v` | Nueva terminal vertical |
| `<A-h>` | Toggle terminal horizontal (persistente, id fijo) |
| `<A-v>` | Toggle terminal vertical (persistente, id fijo) |
| `<A-i>` | Toggle terminal flotante (persistente, id fijo) |
| `<leader>tt` | `[C]` Toggle terminal flotante (toggleterm.nvim, distinto del anterior) |
| `<leader>pt` | Elegir entre terminales ocultas (Telescope) |
| `<C-x>` | (dentro de terminal) salir a modo Normal |

### 2.9 Testing — neotest `[C]` (solo Go configurado: `neotest-go`)

| Tecla | Acción |
|---|---|
| `<leader>tn` | Correr el test más cercano al cursor |
| `<leader>tf` | Correr todos los tests del archivo actual |
| `<leader>ts` | Correr la suite completa |
| `<leader>tl` | Repetir el último test corrido |
| `<leader>to` | Ver el output del test (panel flotante) |
| `<leader>tX` | Detener tests en ejecución |
| `<leader>tw` | Toggle panel resumen (árbol de tests con estado) |

### 2.10 Debug — nvim-dap / dap-go / dap-ui `[C]`

| Tecla | Acción |
|---|---|
| `<leader>du` | Toggle la UI del debugger (scopes, breakpoints, stacks, watches, repl, console) |

Dentro de la UI de dap-ui:

| Tecla | Acción |
|---|---|
| `<CR>` / `<2-LeftMouse>` | Expandir elemento |
| `o` | Abrir |
| `d` | Quitar (breakpoint/watch) |
| `e` | Editar (watch) |
| `r` | Abrir REPL |
| `t` | Toggle |
| `q` / `<Esc>` | Cerrar flotante |

> No hay keymaps globales para `continue`/`step over`/`step into`/`toggle breakpoint` en este repo — se manejan por defecto vía comandos `:lua require('dap').continue()`, etc. Si los usás seguido, conviene agregarlos a `mappings.lua`.

### 2.11 Tareas — overseer.nvim `[C]`

| Tecla | Acción |
|---|---|
| `<leader>or` | Correr una tarea (`go build`, `npm run dev`, `docker compose up`, etc. — detecta el tipo de proyecto) |
| `<leader>ot` | Toggle lista de tareas |
| `<leader>ow` | Ver output en vivo de una tarea (watch) |

### 2.12 Diagnósticos — Trouble `[C]`

| Tecla | Acción |
|---|---|
| `<leader>xx` | Panel de diagnósticos de todo el proyecto |
| `<leader>xb` | Panel de diagnósticos solo del buffer actual |

### 2.13 Surround — mini.surround `[C]` (config) `[Plugin]` (comportamiento)

Sintaxis general: `s<acción><motion o char>`. Ej: `saiw)` agrega `()` alrededor de la palabra bajo el cursor.

| Tecla | Acción |
|---|---|
| `sa` | n, x — Agregar surrounding (pide motion/objeto y el delimitador, ej. `saiw"`) |
| `sd` | n — Eliminar surrounding (pide el delimitador, ej. `sd"`) |
| `sr` | n — Reemplazar surrounding (pide viejo y nuevo delimitador, ej. `sr"'`) |
| `sf` | n — Buscar surrounding hacia la derecha |
| `sF` | n — Buscar surrounding hacia la izquierda |
| `sh` | n — Resaltar el surrounding detectado |
| `sn` | n — Cambiar el rango de búsqueda (`n_lines`) |

### 2.14 Salto rápido — flash.nvim `[C]`

| Tecla | Modo | Acción |
|---|---|---|
| `s` | n, x, o | Mostrar labels sobre matches de 1-2 caracteres en pantalla y saltar al elegido |
| `S` | n, x, o | Saltar entre nodos de treesitter (funciones, clases, bloques) con labels |

> `f`/`F`/`t`/`T` **no están tomados** por flash (`modes.char.enabled = false`), siguen siendo el `find char` nativo de Vim. `r`/`R` (replace char) tampoco se tocan.

### 2.15 Harpoon `[C]` (harpoon2)

| Tecla | Acción |
|---|---|
| `<leader>ha` | Agregar archivo actual a la lista harpoon |
| `<leader>hm` | Abrir/cerrar el menú de harpoon (editar/reordenar la lista) |
| `<A-1>` | Saltar al archivo harpoon #1 |
| `<A-2>` | Saltar al archivo harpoon #2 |
| `<A-3>` | Saltar al archivo harpoon #3 |
| `<A-4>` | Saltar al archivo harpoon #4 |

### 2.16 Outline de símbolos — aerial.nvim `[C]`

| Tecla | Acción |
|---|---|
| `<leader>oa` | Toggle panel de outline (funciones/clases/variables del archivo, vía LSP+treesitter) |
| `<leader>oA` | Toggle ventana de navegación (aerial nav) |

Dentro del panel aerial:

| Tecla | Acción |
|---|---|
| `<CR>` | Saltar al símbolo |
| `<C-s>` | Saltar en split vertical |
| `<C-v>` | Saltar en split horizontal |
| `q` | Cerrar |

### 2.17 Folds semánticos — nvim-ufo `[Plugin]` (automático, sin keymaps propios)

Usa treesitter + indent para folds inteligentes. `foldlevelstart = 99` → todo abierto al entrar. Se opera con los folds **nativos** de Vim (§3.10): `zc` cerrar, `zo` abrir, `za` toggle, `zR` abrir todo, `zM` cerrar todo.

### 2.18 Sesiones — persistence.nvim `[C]`

| Tecla | Acción |
|---|---|
| `<leader>qs` | Restaurar la última sesión guardada (por directorio/branch de git) |
| `<leader>qS` | Guardar la sesión actual manualmente |
| `<leader>qd` | Marcar que **no** se guarde la sesión al salir de esta instancia |

### 2.19 Ordenar — sort.nvim `[C]` + nativo `[Nvim]`

| Tecla | Modo | Acción |
|---|---|---|
| `<leader>qs` | **visual** | Ordenar alfabéticamente las líneas seleccionadas |

Alternativa nativa sin plugin: seleccioná líneas en visual y corré `:sort` (ver §3.12 para variantes: numérico, inverso, único, por regex).

### 2.20 Historial de clipboard — neoclip `[C]`

| Tecla | Acción |
|---|---|
| `<leader>fc` | Abrir historial de yanks/copias en Telescope y pegar el que elijas |

### 2.21 Comentarios `[NvChad]` (comentado nativo de Neovim, vía `gc`)

| Tecla | Modo | Acción |
|---|---|---|
| `<leader>/` | n | Comentar/descomentar la línea actual |
| `<leader>/` | v | Comentar/descomentar la selección |
| `gcc` | n | Igual que `<leader>/` en normal (nativo, sin remapear) |
| `gc{motion}` | n | Comentar aplicando un motion, ej. `gcap` (párrafo) |
| `gc` | v | Comentar la selección (nativo) |

### 2.22 Treesitter textobjects & movimiento por sintaxis `[C]`

| Tecla | Modo | Acción |
|---|---|---|
| `af` | o, x | Seleccionar función completa (outer) |
| `if` | o, x | Seleccionar solo el cuerpo de la función (inner) |
| `ac` | o, x | Seleccionar clase completa (outer) |
| `ic` | o, x | Seleccionar solo el cuerpo de la clase (inner) |
| `]f` | n | Saltar al inicio de la **próxima** función |
| `]c` | n | Saltar al inicio de la **próxima** clase |
| `[f` | n | Saltar al inicio de la función **anterior** |
| `[c` | n | Saltar al inicio de la clase **anterior** |

> Nota: `]c`/`[c` acá son de **treesitter** (saltar función/clase) en el buffer normal; dentro de **nvim-tree** las mismas teclas navegan git hunks — son contextos distintos, no hay conflicto real.

Se usan combinados con operadores: `d af` borra la función entera, `y if` copia solo el cuerpo, `v ic` selecciona el cuerpo de la clase, etc.

### 2.23 Which-key `[NvChad]`

| Tecla | Acción |
|---|---|
| `<leader>wK` | Mostrar **todos** los keymaps registrados (ventana flotante navegable) |
| `<leader>wk` | Pedir un prefijo por input y mostrar solo esos keymaps |

También aparece automáticamente como popup cada vez que empezás una secuencia con `<leader>` y esperás >300ms (`timeoutlen`).

### 2.24 Formateo y Linting — no son keymaps, son automáticos `[C]`

| Qué | Cuándo | Herramienta por filetype |
|---|---|---|
| **Formateo** (`conform.nvim`) | Al guardar (`BufWritePre`), timeout 2s, con fallback a LSP | lua→stylua · go→goimports+gofumpt · js/ts/tsx/jsx/css/html/json/yaml/toml/astro→prettier · markdown→markdownlint-cli2+prettier · dart→dart_format · prisma→prisma |
| **Lint** (`nvim-lint`) | Al guardar, al abrir, al salir de insert (`BufWritePost`/`BufReadPost`/`InsertLeave`) | go→golangci-lint · js/ts/jsx/tsx→eslint_d · markdown→markdownlint · json→jsonlint · yarnspinner→ysc |

También podés forzar formateo manual con `<leader>fm` (§2.1) en cualquier momento.

### 2.25 Go — run/build/vet/fix/format/doc en terminal flotante `[C]` (`mappings.lua`)

Pensado para scripts rápidos de Go: un solo atajo, sin preocuparte de la ruta.
Los seis son keymaps **globales** (no buffer-local por `FileType`, a propósito:
NvChad carga `mappings.lua` con `vim.schedule`, así que un autocmd `FileType go`
se perdería el evento del buffer inicial al abrir `nvim main.go` directo desde
la shell) — cada uno valida `vim.bo.filetype == "go"` al ejecutarse y avisa
con `vim.notify` si no aplica.

| Tecla | Acción | Detalle |
|---|---|---|
| `<leader>rr` | `go run` | Corre en el **directorio del archivo actual**. Si esa carpeta cuelga de un `go.mod` (subiendo con `vim.fs.find`), usa `go run .` (recoge todos los `.go` hermanos = el paquete completo); si no hay módulo, usa `go run <archivo>` (script suelto, sin necesidad de `go.mod`) |
| `<leader>rb` | `go build` | Misma lógica de detección que `rr`, para compilar a un ejecutable |
| `<leader>rv` | Revisor | `golangci-lint run ./...` desde la **raíz del módulo** (si existe) o el directorio del archivo; si `golangci-lint` no está instalado, cae a `go vet ./...` |
| `<leader>rx` | Fix | `golangci-lint run --fix ./...` — autoarregla lo que se pueda |
| `<leader>rf` | Format | Dispara `conform.format()` a demanda (el formateo automático al guardar ya corre solo, ver §2.24) |
| `<leader>rd` | Doc offline | `:GoDoc <cword>` (comando ya incluido en `go.nvim`, sin bindear por defecto) — corre `go doc` sobre la palabra bajo el cursor y lo muestra en floating window markdown. 100% local, no pega a internet: funciona para la stdlib siempre y para cualquier paquete de terceros que ya esté en `~/go/pkg/mod` (cache de módulos) |

`rr`/`rb`/`rv`/`rx` abren/reusan una terminal **flotante** (`toggleterm`/`TermExec`,
mismo mecanismo que `<leader>gg` LazyGit); `rd` usa el floating window nativo de
LSP/go.nvim (no es una terminal).

### 2.26 Otros comandos útiles de este setup

| Comando/Tecla | Acción |
|---|---|
| `:NvCheatsheet` / `<leader>ch` | Abrir el cheatsheet visual de NvChad (categorías con íconos) |
| `:Lazy` | Gestor de plugins (instalar, actualizar, ver logs, profiling) |
| `:Lazy sync` | Sincronizar plugins tras cambiar `plugins/init.lua` (el auto-reload de `.githooks/post-merge` **no** hace esto) |
| `:Mason` | UI para instalar/actualizar LSP servers, formatters, linters, DAP adapters |
| `:MasonToolsUpdate` | Forzar reinstalación de todo lo listado en `mason-tool-installer` |
| `:ConformInfo` | Ver qué formatter se resolvió para el buffer actual |
| `:LspInfo` | Ver qué LSP clients están attachados al buffer |
| `:checkhealth` | Diagnóstico general de salud de Neovim y plugins |

---

## 3. Neovim / Vim — referencia universal (independiente de este config)

Todo lo de acá es **nativo** `[Nvim]`: funciona igual en cualquier instalación de Neovim, con o sin plugins.

### 3.1 Modos

| Tecla | Acción |
|---|---|
| `i` / `a` | Insert antes / después del cursor |
| `I` / `A` | Insert al inicio / final de la línea |
| `o` / `O` | Nueva línea abajo / arriba, entra a insert |
| `v` / `V` / `<C-v>` | Visual char / línea / bloque |
| `R` | Modo Replace (sobrescribe al tipear) |
| `gR` | Modo Virtual Replace (respeta tabs/anchos) |
| `<Esc>` / `jk` (custom) | Volver a Normal |
| `:` | Modo comando (Ex) |
| `q:` | Abrir historial de comandos como buffer editable |

### 3.2 Movimiento (motions)

| Tecla | Acción |
|---|---|
| `h j k l` | Izquierda / abajo / arriba / derecha |
| `w` / `W` | Siguiente palabra / WORD (ignora puntuación) |
| `b` / `B` | Palabra / WORD anterior |
| `e` / `E` | Fin de palabra / WORD |
| `ge` / `gE` | Fin de la palabra / WORD anterior |
| `0` | Inicio absoluto de línea |
| `^` | Primer carácter no-blanco de la línea |
| `$` | Fin de línea |
| `g_` | Último carácter no-blanco de la línea |
| `f{char}` / `F{char}` | Ir al próximo/anterior `{char}` en la línea |
| `t{char}` / `T{char}` | Ir justo antes/después del próximo/anterior `{char}` |
| `;` / `,` | Repetir el último `f/F/t/T` en la misma dirección / inversa |
| `gg` / `G` | Inicio / fin del archivo |
| `{n}G` / `:{n}` | Ir a la línea `n` |
| `{` / `}` | Párrafo anterior / siguiente |
| `%` | Saltar al par de `()`/`{}`/`[]` correspondiente |
| `H` / `M` / `L` | Tope / medio / fondo de la pantalla visible |
| `<C-d>` / `<C-u>` | Media página abajo / arriba |
| `<C-f>` / `<C-b>` | Página completa abajo / arriba |
| `zz` / `zt` / `zb` | Centrar / subir / bajar la línea actual en pantalla |
| `*` / `#` | Buscar próxima/anterior ocurrencia de la palabra bajo el cursor |
| `<C-o>` / `<C-i>` | Retroceder / avanzar en el jumplist (historial de saltos) |
| `` `` ` `` / `` `` ` (backtick) `` | Volver a la posición exacta antes del último salto grande |

### 3.3 Edición

| Tecla | Acción |
|---|---|
| `x` / `X` | Borrar carácter bajo / antes del cursor |
| `dd` | Borrar línea |
| `D` | Borrar desde el cursor hasta fin de línea |
| `cc` / `C` | Cambiar línea completa / desde el cursor |
| `yy` | Copiar (yank) línea |
| `p` / `P` | Pegar después / antes del cursor |
| `]p` / `[p` | Pegar ajustando indentación al contexto |
| `r{char}` | Reemplazar un solo carácter |
| `~` | Alternar mayúscula/minúscula del carácter |
| `g~{motion}` | Alternar case sobre un motion |
| `gu{motion}` / `gU{motion}` | Minúsculas / mayúsculas sobre un motion |
| `J` | Unir línea siguiente a la actual |
| `gJ` | Unir sin agregar espacio |
| `<C-a>` / `<C-x>` | Incrementar / decrementar el número bajo el cursor |
| `u` | Deshacer |
| `<C-r>` | Rehacer |
| `.` | Repetir el último cambio |
| `>>` / `<<` | Indentar / desindentar línea |
| `==` | Auto-indentar línea (usa el LSP si está disponible, `gq`) |
| `gqq` / `gqap` | Formatear (reflow) línea / párrafo a `textwidth` |

### 3.4 Selección visual y text objects

| Tecla | Acción |
|---|---|
| `v` / `V` / `<C-v>` | Entrar a visual char / línea / bloque |
| `gv` | Re-seleccionar la última selección visual |
| `o` | (en visual) Saltar al otro extremo de la selección |
| `iw` / `aw` | Objeto: palabra interior / palabra + espacio |
| `is` / `as` | Objeto: oración interior / con espacio |
| `ip` / `ap` | Objeto: párrafo interior / con línea en blanco |
| `i(` `i)` `ib` | Objeto: dentro de `()` |
| `i{` `i}` `iB` | Objeto: dentro de `{}` |
| `i[` `i]` | Objeto: dentro de `[]` |
| `i"` `i'` `` i` `` | Objeto: dentro de comillas |
| `it` / `at` | Objeto: dentro / incluyendo tag HTML/JSX |
| `af` / `if` / `ac` / `ic` | Objeto de función/clase (treesitter, `[C]`, ver §2.22) |
| En bloque visual: `I` / `A` | Insertar al inicio / final de todas las líneas del bloque |

### 3.5 Buscar y reemplazar

| Tecla / Comando | Acción |
|---|---|
| `/patrón` | Buscar hacia adelante |
| `?patrón` | Buscar hacia atrás |
| `n` / `N` | Repetir búsqueda misma dirección / inversa |
| `*` / `#` | Buscar palabra bajo el cursor adelante / atrás |
| `:%s/vieja/nueva/g` | Reemplazar en todo el archivo |
| `:%s/vieja/nueva/gc` | Igual, pidiendo confirmación por match |
| `:s/vieja/nueva/g` | Reemplazar solo en la línea actual |
| `:'<,'>s/vieja/nueva/g` | Reemplazar solo en el rango visual seleccionado |
| `:%s/\<palabra\>/nueva/g` | Reemplazar solo coincidencias de palabra completa |
| `gn` | Seleccionar la próxima coincidencia de la búsqueda actual (combinable: `cgn` cambia y con `.` repite en la siguiente) |
| `\v` al inicio del patrón | "Very magic" — regex más parecido a PCRE, menos escapes |
| `:noh` (o `<Esc>` en este config) | Quitar resaltado de búsqueda |

### 3.6 Registros, macros, deshacer

| Tecla | Acción |
|---|---|
| `"a yy` | Copiar línea al registro `a` |
| `"a p` | Pegar el contenido del registro `a` |
| `"+ y` / `"+ p` | Copiar / pegar usando el clipboard del sistema |
| `:reg` | Ver contenido de todos los registros |
| `qa` ... `q` | Grabar macro en el registro `a` |
| `@a` | Ejecutar macro `a` |
| `@@` | Repetir la última macro ejecutada |
| `5@a` | Ejecutar macro `a` 5 veces |
| `u` / `<C-r>` | Undo / redo |
| `g-` / `g+` | Moverse al estado anterior/siguiente en el árbol de undo (más allá de un simple redo) |

### 3.7 Marks y saltos

| Tecla | Acción |
|---|---|
| `ma` | Crear mark local `a` en la posición actual |
| `` `a `` | Saltar a la posición exacta del mark `a` |
| `'a` | Saltar al inicio de línea del mark `a` |
| `` `. `` | Saltar al último cambio realizado |
| `` `` ` (dos backticks) `` | Volver a la posición anterior al último salto |
| `:marks` | Listar todos los marks |
| `<leader>ma` | `[NvChad]` Listar marks en Telescope (§2.5) |

### 3.8 Archivos, buffers, ventanas, tabs

| Comando/Tecla | Acción |
|---|---|
| `:e archivo` | Abrir/editar archivo |
| `:w` / `:w archivo` | Guardar / guardar como |
| `:q` / `:qa` | Cerrar ventana / cerrar todo |
| `:wq` / `:x` | Guardar y cerrar |
| `:bn` / `:bp` (`bnext`/`bprevious`) | Buffer siguiente / anterior |
| `:b nombre` | Ir a buffer por nombre (autocompleta) |
| `:bd` | Cerrar buffer |
| `:ls` / `:buffers` | Listar buffers abiertos |
| `:sp` / `:vsp` | Split horizontal / vertical |
| `<C-w>=` | Igualar tamaño de todas las ventanas |
| `<C-w>_` / `<C-w>\|` | Maximizar ventana actual (alto / ancho) |
| `<C-w>q` | Cerrar ventana actual |
| `:tabnew` | Nueva tab |
| `gt` / `gT` | Tab siguiente / anterior |
| `{n}gt` | Ir a la tab número `n` |
| `:cd ruta` | Cambiar directorio de trabajo (afecta a `:e`, Telescope, etc.) |
| `:cd %:h` | `[Nvim]` Cambiar cwd al directorio del archivo actual |

### 3.9 Ir a la raíz del proyecto / directorio de trabajo

| Cómo | Qué hace |
|---|---|
| `:cd %:h` | cwd = carpeta del archivo actual |
| `:lcd %:h` | Igual pero solo para la ventana actual (`lcd` = local cd) |
| `` `:cd `git rev-parse --show-toplevel` ` `` | cwd = raíz del repo git (ejecutando el comando en shell) |
| Abrir nvim-tree y presionar `-` | Sube el **root del árbol** (no el cwd de nvim) al padre |
| `<C-]>` en nvim-tree | Cambia el root del árbol al nodo bajo el cursor |
| `.nvim.lua` en la raíz del proyecto | Este repo tiene `exrc = true`: si existe ese archivo, se ejecuta automáticamente al abrir nvim ahí — ideal para fijar `cd`, opciones o keymaps por proyecto |

### 3.10 Quickfix y location list

| Comando/Tecla | Acción |
|---|---|
| `:copen` / `:cclose` | Abrir / cerrar quickfix list |
| `:cnext` / `:cprev` | Ir al siguiente / anterior ítem |
| `:cc {n}` | Ir al ítem `n` de la quickfix |
| `:lopen` | Abrir location list (por ventana, no global) |
| `<leader>ds` | `[NvChad]` Diagnósticos del buffer → loclist (§2.1) |
| `<C-q>` | `[Plugin]` En Telescope: enviar resultados a quickfix (§2.5) |

### 3.11 Folds nativos

| Tecla | Acción |
|---|---|
| `za` | Toggle fold bajo el cursor |
| `zc` / `zo` | Cerrar / abrir fold |
| `zC` / `zO` | Cerrar / abrir fold y todos sus hijos |
| `zR` | Abrir **todos** los folds del buffer |
| `zM` | Cerrar **todos** los folds del buffer |
| `zj` / `zk` | Saltar al próximo / anterior inicio de fold |

En este setup los folds los calcula `nvim-ufo` (treesitter+indent), pero se operan igual con las teclas de arriba.

### 3.12 Diff mode

| Comando/Tecla | Acción |
|---|---|
| `nvim -d archivo1 archivo2` | Abrir dos archivos en modo diff |
| `:diffthis` | Marcar la ventana actual para diff |
| `:diffoff` | Salir del modo diff en la ventana actual |
| `:diffoff!` | Salir del modo diff en todas las ventanas |
| `]c` / `[c` | Saltar al próximo / anterior cambio (en modo diff nativo) |
| `do` | `diff obtain` — traer el cambio de la otra ventana |
| `dp` | `diff put` — mandar el cambio a la otra ventana |
| `:Gitsigns diffthis` | `[Plugin]` Diff del buffer contra el índice de git (§2.7) |

### 3.13 Ordenar

| Comando | Acción |
|---|---|
| `:sort` | Ordenar todo el buffer alfabéticamente |
| `:'<,'>sort` | Ordenar solo el rango/selección visual |
| `:sort!` | Orden inverso |
| `:sort u` | Ordenar y eliminar duplicados |
| `:sort n` | Ordenar numéricamente |
| `:sort /patrón/` | Ordenar por lo que matchea después del patrón (ignora el patrón como key) |
| `<leader>qs` (visual) | `[C]` Igual que `:sort`, vía `sort.nvim` (§2.19) |

### 3.14 Otros comandos útiles nativos

| Comando | Acción |
|---|---|
| `:g/patrón/d` | Borrar todas las líneas que matchean `patrón` |
| `:g!/patrón/d` (o `:v/patrón/d`) | Borrar todas las líneas que **no** matchean |
| `:g/patrón/normal @a` | Ejecutar la macro `a` en cada línea que matchea |
| `:%!comando` | Filtrar todo el buffer a través de un comando de shell |
| `:'<,'>!sort` | Igual pero solo sobre la selección |
| `:r archivo` | Insertar contenido de otro archivo en el cursor |
| `:r !comando` | Insertar la salida de un comando de shell |
| `gf` | Abrir el archivo cuyo nombre está bajo el cursor |
| `<C-w>f` | Abrir el archivo bajo el cursor en un split nuevo |
| `gx` | Abrir la URL bajo el cursor en el navegador |

---

## Cómo mantener este cheatsheet al día

Si agregás/cambiás un keymap:
- Custom propio → `nvim/lua/mappings.lua` o el bloque `keys = {...}` del plugin en `nvim/lua/plugins/init.lua`.
- Actualizá la tabla correspondiente acá y, si aplica, el árbol de `<leader>` en §1.
