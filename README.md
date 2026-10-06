# my-nvim-setup

My Neovim + NvChad (v2.5) configuration for Windows 11.

## Usage

Clone the repo, then create a symlink so Neovim picks up the config:

```powershell
# Remove existing config (backup first if needed)
Move-Item "$env:LOCALAPPDATA\nvim" "$env:LOCALAPPDATA\nvim.bak" -ErrorAction SilentlyContinue

# Symlink repo to nvim config path
New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target "C:\path\to\my-nvim-setup\nvim"
```

Then open Neovim — lazy.nvim will auto-install all plugins.

## What's included

- **LSP**: gopls, vtsls, tailwindcss, eslint, jsonls (with SchemaStore), prismals, dockerls, astro, html, cssls, emmet_ls
- **Formatters**: stylua, goimports+gofumpt, prettier, dart_format, markdownlint-cli2
- **Linters**: golangci-lint, eslint_d, markdownlint, jsonlint, ysc (YarnSpinner)
- **Debugging**: nvim-dap + nvim-dap-go + nvim-dap-ui
- **Tools**: Telescope, nvim-tree, Trouble, fidget, Copilot (via cmp), autotag, toggleterm, lazygit, rest.nvim, git-blame, mason-tool-installer
- **Custom**: YarnSpinner syntax highlighting + ftdetect, project-local `.nvim.lua` support (`exrc`)

## Keymaps

### Menús contextuales del leader

El popup de `<leader>` muestra solo lo que aplica al archivo actual (keymaps buffer-local, ver `nvim/lua/menus/` y el campo `menu` de cada archivo en `nvim/lua/languages/`). Los comandos corren en un terminal flotante desde la raíz del proyecto.

| Prefijo | Aparece en | Acciones |
|---------|-----------|----------|
| `<leader>g` | Go (`go`, `gomod`, `gowork`) | `r` run, `b` build, `v` vet/lint, `f` format, `t` mod tidy, `x` lint --fix, `m` test |
| `<leader>d` | Dart | `r` run, `d` debug, `h` hot reload, `R` restart, `q` quit, `D` devices, `e` emulators, `o` outline, `l` log, `t` devtools, `p` pub get, `m` test, `v` analyze, `x` dart fix, `f` format |
| `<leader>r` | Rust | `r` run, `b` build, `m` test, `c` check, `v` clippy, `x` clippy --fix, `f` cargo fmt |
| `<leader>p` | Python | `r` run (uv si hay pyproject), `i` REPL, `m` pytest, `t` pytest del archivo, `v` ruff check, `x` ruff --fix, `f` ruff format |
| `<leader>t` | TS / JS | `r` elegir script, `d` dev, `b` build, `m` test, `v` lint, `c` tsc, `x` eslint --fix, `f` format, `o` organize imports, `i` install (detecta pnpm/yarn/bun/npm) |
| `<leader>m` | Markdown | `r` toggle render, `o` outline, `f` format |
| `<leader>s` | CSS / SCSS / Less | `f` format, `c` color preview, `o` outline |
| `<leader>j` / `<leader>k` | Java / Kotlin | `r` run, `b` build, `m` test, `v` check/verify, `c` clean (Gradle o Maven) |
| `<leader>G` | Cualquier archivo dentro de un repo git | `t` status, `b` blame toggle |

### Settings (`<leader>S`, global)

| Key | Action |
|-----|--------|
| `<leader>St` | Alternar tema: default (gruvbox) ↔ heredado de la terminal (Alacritty) |
| `<leader>Sd` | Tema por defecto |
| `<leader>Sa` | Tema de la terminal |
| `<leader>Sr` | Re-sincronizar la paleta de la terminal |
| `<leader>Sp` | Selector de temas de NvChad |
| `<leader>Si` | Info del tema activo |

### Globales

| Key | Action |
|-----|--------|
| `<leader>tt` | Toggle float terminal |
| `<leader>du` | Toggle DAP UI |
| `<leader>xx` | Diagnostics (Trouble) |
| `<leader>xb` | Buffer diagnostics |
| `sa` | Add surrounding delimiter (visual/normal) |
| `sd` | Delete surrounding delimiter |
| `sr` | Replace surrounding delimiter |
| `s` | Flash jump to word |
| `S` | Flash jump via treesitter (classes, functions) |
| `<leader>tn` | Run nearest test (neotest) |
| `<leader>tf` | Run current test file |
| `<leader>ts` | Run test suite |
| `<leader>tl` | Run last test |
| `<leader>to` | Show test output |
| `<leader>or` | Run task (overseer) |
| `<leader>ot` | Toggle task list |
| `;` | Command mode |
| `jk` | Escape (insert mode) |
| `<C-LeftMouse>` | Go to definition |
