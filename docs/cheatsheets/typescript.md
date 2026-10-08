# TypeScript / JavaScript

Filetypes: `typescript`, `typescriptreact`, `javascript`, `javascriptreact`.

## Herramientas

| Qué | Con |
|---|---|
| LSP | `vtsls` (TS/JS) y `eslint` (eslint-lsp) |
| Formato (al guardar y `<leader>fm`) | `prettier` |
| Lint | `eslint_d` |
| Extra | treesitter (`javascript`, `typescript`, `tsx`), `nvim-ts-autotag` (cierra/renombra tags JSX), `package-info` (versiones en `package.json`), preview de colores Tailwind |

## Menú `<leader>t` (solo en ts/tsx/js/jsx)

El gestor de paquetes se detecta por lockfile: `pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, `bun.lock(b)` → bun, si no npm.
Usa los scripts de `package.json` cuando existen.

| Tecla | Acción |
|---|---|
| `tr` | elegir un script de `package.json` y correrlo (`<pm> run …`) |
| `td` | `dev` (script `dev`) |
| `tb` | `build` (script `build`) |
| `tm` | `<pm> test` |
| `tv` | lint (script `lint`, o `eslint .` si no existe) |
| `tc` | typecheck: `tsc --noEmit` |
| `tx` | `eslint --fix` del archivo actual |
| `tf` | formatear |
| `to` | organizar imports (code action `source.organizeImports`) |
| `ti` | instalar dependencias |

## Útiles generales aquí

| Tecla | Acción |
|---|---|
| `gd` / `grr` | definición / dónde se usa |
| `<leader>ca` | code actions (imports faltantes, quick fixes de eslint) |
| `grn` | renombrar símbolo (LSP, nativo) |
| `K` | hover con tipos |
| `daf` / `dif` | borrar función entera / su cuerpo |
| `Alt+j` / `Alt+k` | mover línea o bloque |
| `sa` / `sd` / `sr` | surround (comillas, paréntesis, tags) |

## Notas

- Los scripts corren en la terminal integrada, en la raíz del proyecto (donde está `package.json`).
- `npx --no-install`: no descarga nada; usa lo que ya está en `node_modules`.
