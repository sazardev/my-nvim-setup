# Python

Filetype: `python`.

## Herramientas

| Qué | Con |
|---|---|
| Treesitter | `python` |
| LSP / formatter / linter | **no hay declarados** en el registro (solo menú + treesitter); el formato/lint se hace con `ruff` desde el menú |

> Si quieres LSP o formato automático al guardar, se añade en `lua/languages/python.lua` (campos `lsp`, `mason`, `formatters`, `linters`) sin tocar nada más.

## Menú `<leader>p` (solo en `*.py`)

Usa `uv run` si `uv` está instalado y el proyecto tiene `pyproject.toml`; si no, `python3`.
Raíz del proyecto: donde esté `pyproject.toml`, `pytest.ini`, `setup.cfg` o `.git`.

| Tecla | Acción |
|---|---|
| `pr` | correr el archivo actual |
| `pi` | REPL con el archivo cargado (`python3 -i`) |
| `pm` | `pytest` (todo el proyecto) |
| `pt` | `pytest` del archivo actual |
| `pv` | `ruff check .` |
| `px` | `ruff check --fix .` |
| `pf` | `ruff format` del archivo (guarda antes) |

Las acciones de ruff avisan si `ruff` no está instalado.

## Útiles generales aquí

| Tecla | Acción |
|---|---|
| `daf` / `dif` | borrar función entera / su cuerpo (def) |
| `dac` / `dic` | clase entera / su interior |
| `]f` / `[f` | siguiente / anterior función |
| `<leader>fr` | reemplazo global |
| `za` | plegar por indentación/treesitter |
