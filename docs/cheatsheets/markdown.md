# Markdown

Filetype: `markdown`.

## Herramientas

| Qué | Con |
|---|---|
| Formato (al guardar y `<leader>fm`) | `markdownlint-cli2` (corrige reglas) y luego `prettier` |
| Lint | `markdownlint` |
| Render | `render-markdown.nvim` (títulos, listas, código, checkboxes con estilo) |
| Treesitter | `markdown` |

## Menú `<leader>m` (solo en `*.md`)

| Tecla | Acción |
|---|---|
| `mr` | activar/desactivar el render |
| `md` | mostrar/ocultar diagnósticos del linter **solo en este buffer** (el linter sigue corriendo) |
| `mz` | modo lectura (centrado, sin ruido) |
| `ms` | ortografía (es, en) |
| `mw` | palabras y tiempo de lectura |
| `mx` | marcar/desmarcar checkbox `- [ ]` |
| `mo` | outline (Aerial) |
| `mf` | formatear |

## Útiles aquí

| Tecla | Acción |
|---|---|
| `sa` / `sd` / `sr` | surround: `**negrita**`, `` `código` ``, `[texto]()` |
| `gcc` | comentar (`<!-- -->`) |
| `]s` / `[s` | siguiente / anterior error ortográfico (con `ms` activo) |
| `z=` | sugerencias de ortografía |
