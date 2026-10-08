# Cheatsheets

Referencia rápida de lo que tiene esta config. `<leader>` = `Space`.

| Cheatsheet | Qué cubre |
|---|---|
| [go.md](go.md) | **Go a fondo**: tags de struct, snippets, completado contextual, menú `<leader>g` |
| [typescript.md](typescript.md) | TypeScript / JavaScript / TSX |
| [python.md](python.md) | Python |
| [rust.md](rust.md) | Rust |
| [dart-flutter.md](dart-flutter.md) | Dart / Flutter |
| [java-kotlin.md](java-kotlin.md) | Java y Kotlin (Gradle / Maven) |
| [lua.md](lua.md) | Lua (la propia config) |
| [markdown.md](markdown.md) | Markdown |
| [web.md](web.md) | HTML, CSS, Tailwind, Astro |
| [data-formats.md](data-formats.md) | JSON, YAML, TOML, Docker, Prisma, YarnSpinner |

## Cómo funciona el leader

Cada lenguaje tiene **su propia letra** bajo `<leader>` y **solo existe en buffers de ese filetype**.
Pulsa `<leader>` y which-key muestra únicamente lo que aplica al archivo actual (sin delay).

| Letra | Menú | Dónde existe |
|---|---|---|
| `g` | Go | `*.go` |
| `t` | TypeScript / JavaScript | ts, tsx, js, jsx |
| `p` | Python | `*.py` |
| `r` | Rust | `*.rs` |
| `d` | Dart / Flutter | `*.dart` |
| `j` / `k` | Java / Kotlin | `*.java` / `*.kt` |
| `m` | Markdown | `*.md` |
| `s` | CSS | css, scss, less |
| `G` | Git | cualquier archivo dentro de un repo |
| `P` | Session | global |
| `S` | Settings (tema) | global |

Los menús de lenguaje abren una terminal integrada (toggleterm) y corren los comandos en la **raíz del proyecto**
(detectan `go.mod`, `package.json`, `Cargo.toml`, `pubspec.yaml`, `pom.xml`/`build.gradle`...).

## Atajos globales

### Edición
| Tecla | Acción |
|---|---|
| `jk` (insert) | salir a normal |
| `;` | `:` (modo comando) |
| `<leader>w` / `Ctrl+s` | guardar |
| `<leader>q` | cerrar buffer (o salir si es el último) |
| `<leader>d` | borrar **sin copiar** (no pisa el portapapeles): `<leader>dd`, `<leader>dw`, visual `<leader>d` |
| `<leader>/` | comentar línea / selección |
| `Ctrl+c` | copiar todo el archivo |
| `<leader>fm` | formatear (conform) — también se formatea al guardar |
| `Alt+h/j/k/l` | mover línea o bloque (mini.move) |
| `Ctrl+↓` / `Ctrl+↑` | multicursor nativo: bloque visual línea a línea, luego `I`, `A`, `c` o `$A` |
| `sa` / `sd` / `sr` | surround: añadir / borrar / cambiar delimitadores (mini.surround) |
| `s` / `S` | flash: saltar a una palabra / a un nodo treesitter |

### Textobjects (treesitter)
| Tecla | Agarra |
|---|---|
| `af` / `if` | función entera / solo su cuerpo |
| `ac` / `ic` | clase o tipo entero / su interior |
| `]f` / `[f` | siguiente / anterior función |

Combínalos con operadores: `daf` borra la función, `dif` borra el cuerpo, `cif` lo cambia, `yaf` la copia, `vaf` la selecciona.
Para llaves de cualquier bloque (`if`, `for`...): `di{` (interior), `da{` (con llaves), `%` salta a la pareja.

### Navegación y búsqueda
| Tecla | Acción |
|---|---|
| `<leader>ff` | buscar archivos (respeta `.gitignore`), **con preview** del archivo |
| `<leader>fw` | grep en el proyecto (con preview de la coincidencia) |
| `<leader>fb` / `<leader>fo` | buffers abiertos / archivos recientes |
| `<leader>fr` | buscar y reemplazar global (grug-far) |
| `Ctrl+n` / `<leader>e` | explorador nvim-tree: alternar / enfocar |
| `<leader>ha` / `<leader>hm` | harpoon: marcar archivo / menú |
| `<leader>h1` … `h4` | harpoon: saltar al archivo 1…4 |
| `<leader>H` | historial de archivos de la sesión |
| `gd` | ir a la definición (también `Ctrl+click`) |
| `grr` | ver dónde se usa (lista) |
| `Esc` | volver a donde estabas tras `gd`/`grr`; cierra popups; quita resaltado |
| `Ctrl+o` / `Ctrl+i` | atrás / adelante en el historial de saltos |
| `K` | hover (documentación) |
| `<leader>ca` | code actions del LSP |

### Diagnósticos
| Tecla | Acción |
|---|---|
| `<leader>xd` | diagnóstico de la línea en popup (púlsalo otra vez para entrar y copiar) |
| `<leader>xx` | lista de diagnósticos (Trouble) |
| `]d` / `[d` | siguiente / anterior diagnóstico (nativo) |

### Telescope: preview siempre visible
El layout es `flex`: en ventanas anchas (≥ 110 columnas) el preview va a la **derecha**; en angostas pasa **abajo** del listado.
Nunca se oculta (antes Telescope lo apagaba solo por debajo de 120 columnas). Se ajusta en `lua/plugins/navigation/telescope.lua`.

### nvim-tree
| Tecla | Acción |
|---|---|
| `Enter` sobre archivo | abre y cierra el árbol |
| `I` | mostrar / ocultar lo ignorado por git |
| `<leader>nd` | crear carpeta(s) con vista de la ubicación |
| `<leader>nx` | borrar carpeta con su contenido (avisa cuántos archivos) |

### Terminal
| Tecla | Acción |
|---|---|
| `Alt+i` / `Alt+h` / `Alt+v` | terminal flotante / horizontal / vertical (NvChad) |
| `Esc` (dentro) | cerrar la terminal |
| `Ctrl+x` | salir al modo normal dentro de la terminal |

### Otros
| Tecla / comando | Acción |
|---|---|
| `:TSContext toggle` | contexto fijo de la función/clase arriba |
| `za` / `zc` / `zo` | plegar / desplegar (folds por treesitter con nvim-ufo; todo abierto al iniciar) |
| `<leader>Gb` | git blame (apagado por defecto: sin costo) |
| `:Lazy sync` | instalar/actualizar plugins (el auto-reload no lo hace) |

## Autocompletado (blink.cmp)

| Tecla | Acción |
|---|---|
| `Tab` / `Shift+Tab` | siguiente / anterior opción; si no hay menú, salta entre placeholders del snippet |
| `Enter` | aceptar la opción elegida |
| `Ctrl+Space` | abrir el menú / mostrar u ocultar la documentación |
| `Ctrl+e` | cerrar el menú |

- La ventanita de documentación aparece **al instante** al seleccionar (`auto_show_delay_ms = 0`) y muestra, en los snippets, **lo que se va a insertar**.
- Nada viene preseleccionado, salvo dentro de un tag de struct de Go (ahí `Enter` acepta la primera sugerencia).
- Fuentes: LSP, path, snippets, buffer. En Go se suman `gotags` y `gosmart`; en Lua, `lazydev`.

## Sesiones — `<leader>P`

| Tecla | Acción |
|---|---|
| `<leader>Pr` | restaurar la sesión de esta carpeta |
| `<leader>Ps` | elegir sesión de cualquier proyecto |
| `<leader>Pl` | restaurar la última |
| `<leader>Pw` | guardar ahora |
| `<leader>Px` | no guardar al salir |

Una sesión por carpeta (y por rama de git; `main`/`master` usan la base). No se restauran solas:
botón **Restore Session** (`rs`) del dashboard.

## Git — `<leader>G`

| Tecla | Acción |
|---|---|
| `Gt` | status (Telescope) |
| `Gb` | blame toggle |
| `Gd` | diff de todos los cambios (Diffview) |
| `Gf` / `Gr` | historial de este archivo / del repo |
| `Gq` | cerrar Diffview |
| `Go` / `GT` / `GB` / `GN` | conflicto: quedarme con ours / theirs / ambos / ninguno |
| `Gn` / `Gp` | conflicto siguiente / anterior |
| `Gl` | conflictos del repo en quickfix |

## Tema — `<leader>S`

| Tecla | Acción |
|---|---|
| `St` | alternar tema (gruvbox ↔ gruvbox_light) |
| `Sd` | tema por defecto |
| `Sa` | tema heredado de la terminal (Alacritty), se sigue en vivo |
| `Sr` | re-sincronizar el tema de la terminal |
| `Sp` | selector de temas |
| `Si` | info del tema activo |

## Modo ligero

En equipos con ≤ 2 GB de RAM se apagan LSP, go.nvim y golangci-lint (queda `go vet`). Treesitter, conform y nvim-lint siguen.
Forzar con `NVIM_LIGHT=1|0`. Ajustes por máquina en `lua/local.lua` (ignorado por git).

## Añadir cosas

- **Lenguaje**: `lua/languages/<nombre>.lua` + agregarlo a `NAMES` en `languages/init.lua`.
- **Plugin**: un archivo en `lua/plugins/<grupo>/`.
- **Snippet de Go**: `nvim/snippets/go.json` (formato VSCode).
