# 🐹 w3m + Neovim — navegador de terminal enfocado en documentación de Go

> ⚠️ **Nota de alcance**: este repo (`my-nvim-setup`) es la config de Neovim
> para **Windows 11** (ver `README.md`/`AGENTS.md`). w3m y su integración con
> Neovim son cosas de **Linux/CachyOS** (la máquina donde además vivo yo,
> Claude, al ayudarte) y por eso los archivos reales viven fuera de este
> repo, en el sistema. Esta hoja es solo la **documentación/referencia**
> para poder reproducir el setup en cualquier máquina Linux nueva —
> cópialos tal cual si formateas o migras de equipo.

## 1. Qué es y por qué

`w3m` es un navegador web en modo texto para la terminal. Renderiza HTML,
soporta formularios, tablas, colores, mouse e imágenes (vía sixel). La idea
de este setup: leer documentación de Go (pkg.go.dev, blogs, READMEs de
paquetes) y buscar en internet **sin salir de la terminal**, con controles
que ya conoces de vim/Neovim.

## 2. Instalación (CachyOS / Arch)

```bash
sudo pacman -S --needed w3m libsixel
```

- `w3m` — ya viene compilado con soporte de imágenes/color/mouse en CachyOS.
- `libsixel` (da el binario `img2sixel`) — necesario para ver imágenes
  inline. El método clásico de w3m (`w3mimgdisplay`, dibuja overlays vía
  X11) **no funciona en Wayland** ni en terminales renderizadas por GPU
  (Warp, Kitty en algunos modos, etc.), así que usamos sixel en su lugar.

## 3. Archivos de configuración

### `~/.w3m/config`

```conf
editor              nvim

display_charset     UTF-8
document_charset    UTF-8
system_charset      UTF-8
follow_locale       0
fold_line           1
fold_textarea       1
fold_pre            1
tabstop             4

display_image       1
auto_image          1
image_scale         100
inline_img_protocol 2
ext_image_viewer    0

color               1
use_mouse           1
active_style        1

use_cookie          1
accept_cookie       1
show_cookie         0

display_borders     1

ignorecase_search   1
smartcase_search    1
wrap_search         1
```

Si las imágenes no se ven en tu terminal, cambia `inline_img_protocol` a
`0` (X11 clásico) o pon `display_image` en `0` para navegar sin imágenes
(el texto se ve perfecto igual).

### `~/.w3m/keymap`

Se **suma** al keymap por defecto de w3m (que ya es muy vim-like: `h j k
l` mover, `b`/`SPC` paginar, `g`/`G` inicio/fin, `/` `?` buscar, `n`/`N`
repetir búsqueda, `B` atrás, `U` ir a URL, `E` editar fuente en `$EDITOR`
→ nvim). Solo añadimos dos atajos de búsqueda directa (usan teclas libres
en el keymap por defecto):

```conf
# 'd' -> mnemotécnico DuckDuckGo: precarga el prompt de "abrir URL" con
# el endpoint de búsqueda, solo escribes la consulta y Enter.
keymap	d	GOTO	"https://duckduckgo.com/html/?q="

# 'p' -> mnemotécnico pkg.go.dev: busca paquetes/símbolos de Go directo.
keymap	p	GOTO	"https://pkg.go.dev/search?q="
```

### `~/.w3m/bookmark.html` — páginas Go listas

Formato nativo de bookmarks de w3m (compatible con `M-a` para agregar más
desde dentro del navegador). Ábrelas con `M-b` o directo desde la shell
con `w3m -B`.

```html
<html><head><title>Bookmarks</title></head>
<body>
<h1>Bookmarks</h1>
<h2>Go — docs y paquetes</h2>
<ul>
<li><a href="https://pkg.go.dev/">pkg.go.dev — buscador de paquetes</a>
<li><a href="https://pkg.go.dev/std">Standard library (pkg.go.dev/std)</a>
<li><a href="https://go.dev/doc/effective_go">Effective Go</a>
<li><a href="https://go.dev/ref/spec">Go Language Specification</a>
<li><a href="https://go.dev/ref/mod">Go Modules Reference</a>
<li><a href="https://gobyexample.com/">Go by Example</a>
<li><a href="https://go.dev/blog/">The Go Blog</a>
<li><a href="https://github.com/avelino/awesome-go">Awesome Go (lista de paquetes)</a>
<li><a href="https://pkg.go.dev/github.com/gin-gonic/gin">Gin — web framework</a>
<li><a href="https://pkg.go.dev/github.com/labstack/echo/v4">Echo — web framework</a>
<li><a href="https://pkg.go.dev/github.com/gofiber/fiber/v2">Fiber — web framework</a>
<li><a href="https://pkg.go.dev/github.com/spf13/cobra">Cobra — CLI framework</a>
<li><a href="https://pkg.go.dev/gorm.io/gorm">GORM — ORM</a>
<li><a href="https://pkg.go.dev/github.com/stretchr/testify">Testify — testing/asserts</a>
</ul>
<h2>General</h2>
<ul>
<li><a href="https://duckduckgo.com/html/">DuckDuckGo</a>
</ul>
</body>
</html>
```

Para agregar un paquete nuevo a la lista: navega a su página en pkg.go.dev
y pulsa `M-a` (Add Bookmark) dentro de w3m — no hace falta editar el HTML
a mano.

## 4. Shell (`~/.zshrc`)

```bash
# --- w3m: navegador de texto en terminal ---
export WWW_HOME="https://duckduckgo.com/html/"   # tecla 'U' con GOTO_HOME / al abrir sin argumentos
alias w3="w3m \$WWW_HOME"

# ddg <consulta> — búsqueda rápida en DuckDuckGo desde la shell
ddg() { w3m "https://duckduckgo.com/html/?q=$*"; }
```

## 5. Integración con Neovim

Vive en `~/.config/nvim/lua/mappings.lua` (config real de esta máquina;
usa `toggleterm`/`TermExec`, ya presente en el setup para lazygit/lazydocker):

```lua
-- w3m: navegador de texto en terminal (usa nvim como editor externo vía $EDITOR)
if vim.fn.executable "w3m" == 1 then
  map("n", "<leader>ww", "<cmd>TermExec cmd=w3m<cr>", { desc = "Abrir w3m (DuckDuckGo)" })

  map("n", "gx", function()
    local line = vim.api.nvim_get_current_line()
    local url = line:match "https?://[%w%-%._~:/?#%[%]@!$&'()*+,;=%%]+" or vim.fn.expand "<cfile>"
    vim.cmd("TermExec cmd=w3m " .. vim.fn.shellescape(url))
  end, { desc = "Abrir URL bajo el cursor en w3m" })

  -- <leader>wg: busca un paquete/símbolo de Go en pkg.go.dev sin salir de nvim
  map("n", "<leader>wg", function()
    vim.ui.input({ prompt = "pkg.go.dev buscar: " }, function(query)
      if not query or query == "" then
        return
      end
      local url = "https://pkg.go.dev/search?q=" .. query:gsub(" ", "+")
      vim.cmd("TermExec cmd=w3m " .. vim.fn.shellescape(url))
    end)
  end, { desc = "Buscar paquete Go en pkg.go.dev" })

  -- <leader>wb: abre las bookmarks de w3m (páginas Go listas)
  map("n", "<leader>wb", function()
    vim.cmd("TermExec cmd=" .. vim.fn.shellescape "w3m -B")
  end, { desc = "Abrir bookmarks de w3m" })
end
```

| Atajo | Acción |
|---|---|
| `<leader>ww` | Abre w3m en terminal flotante, arranca en DuckDuckGo |
| `<leader>wg` | Pide un texto (`vim.ui.input`) y busca ese paquete/símbolo en pkg.go.dev |
| `<leader>wb` | Abre las bookmarks de w3m (todas las páginas Go listas) |
| `gx` | Abre la URL de la línea actual (o bajo el cursor) en w3m — como el `gx` clásico de netrw |

## 6. Controles dentro de w3m (ya son casi 100% vim)

| Tecla | Acción |
|---|---|
| `h` `j` `k` `l` | Mover cursor |
| `SPC` / `b` | Página siguiente / anterior |
| `g` / `G` | Inicio / fin del documento |
| `TAB` / `M-TAB` | Siguiente / anterior enlace |
| `RET` (Enter) | Seguir enlace / enviar formulario |
| `/` `?` | Buscar hacia adelante / atrás |
| `n` `N` | Repetir búsqueda (mismo sentido / inverso) |
| `B` | Atrás en el historial |
| `U` | Abrir URL (prompt) |
| `d` | Buscar en DuckDuckGo (prompt precargado) |
| `p` | Buscar paquete en pkg.go.dev (prompt precargado) |
| `T` | Nueva pestaña |
| `{` `}` | Pestaña anterior / siguiente |
| `M-a` | Agregar página actual a bookmarks |
| `M-b` | Ver bookmarks |
| `E` | Editar el fuente de la página en `$EDITOR` (nvim) |
| `=` | Info de la página actual (URL, tipo, etc.) |
| `q` | Salir |

Para escribir en un campo de texto (buscador, formularios): navega hasta
el campo con `TAB` o clic de mouse, y **escribe directamente** — no hace
falta ningún modo especial. `Enter` envía.

## 7. Flujo típico para documentación de Go

- **Desde nvim, buscar un paquete puntual**: `<leader>wg` → escribe
  `gorilla/mux` (o `encoding/json`, `context`, etc.) → Enter. Abre
  pkg.go.dev con los resultados.
- **Ir directo a una página ya conocida**: `<leader>wb` → elige de la
  lista (Effective Go, Go by Example, Gin, Cobra, ...).
- **Duda rápida y genérica**: `<leader>ww` → `d` → escribe la consulta →
  Enter (DuckDuckGo).
- **Desde la shell, sin abrir nvim**: `ddg cómo hacer context cancellation
  en go` o `w3m -B` para ir directo a bookmarks.
- **Un link que ves en un README o comentario dentro de nvim**: cursor en
  la línea → `gx`.

## 8. Flujo offline (sin internet)

A diferencia de w3m/DuckDuckGo/pkg.go.dev (todo lo de arriba, que necesita
red), la documentación de Go vive **en el propio código fuente** (comentarios
`//` antes de cada símbolo) y las siguientes herramientas la leen del disco —
no dependen de internet para nada que ya tengas descargado. Esto sí es
multiplataforma: `<leader>rd` vive en `mappings.lua` (el repo real, no config
Linux-only como el resto de esta hoja).

| Herramienta | Cómo | Alcance offline |
|---|---|---|
| `go doc <pkg>` / `go doc <pkg.Símbolo>` | Terminal, sin salir de nada | stdlib siempre + cualquier paquete de terceros que ya esté en `~/go/pkg/mod` (cache de módulos: todo lo que alguna vez hiciste `go get`/`go build` mientras tenías red) |
| `<leader>rd` (dentro de nvim) | Cursor sobre el símbolo → `<leader>rd` | Igual que `go doc`, pero en floating window markdown vía `:GoDoc` (comando de `go.nvim`, ya incluido en el setup — ver §2.25 del cheatsheet principal) |
| `K` (LSP hover, gopls) | Cursor sobre el símbolo → `K` | Ya funciona hoy sin configurar nada; gopls lee todo localmente |
| `godoc -http=:6060` | Instalar **una vez, con internet**: `go install golang.org/x/tools/cmd/godoc@latest`. Después, offline: `godoc -http=:6060 &` y navegar `http://localhost:6060` (con w3m o cualquier navegador) | Experiencia completa tipo pkg.go.dev pero local: búsqueda, links entre paquetes, todo lo que tengas en el module cache |

**Límite real**: un paquete que nunca descargaste no tiene código fuente
local, así que ninguna de estas herramientas puede mostrar nada de él sin
internet — ahí no hay vuelta.
