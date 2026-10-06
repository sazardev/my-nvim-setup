# my-nvim-setup

Neovim + NvChad v2.5 config — not an application. No tests, CI, or build system.

## Repo structure

- `nvim/` — mirrors `%LOCALAPPDATA%\nvim` on Windows. Symlink it:
  ```powershell
  New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target "C:\path\to\my-nvim-setup\nvim"
  ```
- `.agents/skills/caveman*` — OpenCode skills (lockfile: `skills-lock.json`)
- `.gitignore` — excludes `.claude/` (machine-specific Claude config)

## How it works

- Plugins auto-install via `lazy.nvim` on first open
- Activate the auto-reload hook once per clone: `git config core.hooksPath .githooks` (the hook picks the right data dir for Windows or Linux)
- LSP servers and tools (gopls, vtsls, stylua, prettier, eslint_d, dart, etc.) auto-install via `mason-tool-installer`
- No manual setup beyond the symlink
- **Auto-reload**: `.githooks/post-merge` creates a marker on `git pull`; `core/autocmds/reload.lua` detects it on `UIEnter` and runs `luafile $MYVIMRC` to reload config automatically

## Architecture

Un archivo = una responsabilidad. Entrada mínima en `nvim/init.lua`; todo lo demás es modular:

```
nvim/
├── init.lua                  # solo bootstrap (lazy + core)
└── lua/
    ├── core/                 # arranque: settings, light, lazy, options, clipboard, theme
    │   ├── settings.lua      #   TODOS los ajustes configurables (+ overrides locales)
    │   ├── keymaps/          #   cleanup (quita NvChad) · general
    │   └── autocmds/         #   reload · treesitter · ui
    ├── languages/            # 1 archivo por lenguaje: DECLARA treesitter, lsp, mason, formatters, linters, menú
    │   ├── init.lua          #   registro: agrega las declaraciones y las sirve a cada consumidor
    │   └── actions/          #   acciones de los menús (go, dart, typescript, python, rust, jvm...)
    ├── appearance/           # tema por defecto vs heredado de la terminal (Alacritty → base46)
    ├── themes/               # temas de usuario de base46 (terminal.lua se genera de la paleta)
    ├── servers/              # overrides por servidor LSP (servers/<nombre>.lua) + cargador
    ├── menus/                # menús contextuales del leader (buffer-locales) + contexto Git
    ├── plugins/<grupo>/      # 1 spec de lazy por plugin: core lsp tools syntax languages navigation editing git ui
    ├── ui/                   # dashboard, highlights, lualine (tema + componentes)
    ├── utils/                # helpers puros: terminal, project, actions, git, log, telescope
    └── chadrc.lua            # solo compone: tema + dashboard + ui de NvChad
```

**Añadir un lenguaje**: crea `lua/languages/<nombre>.lua` (contrato en `languages/init.lua`) y agrégalo a `NAMES`. No hay que tocar mason, treesitter, conform, nvim-lint ni LSP: salen del registro. Overrides de un servidor: `lua/servers/<servidor>.lua`.

**Añadir un plugin**: un archivo en `lua/plugins/<grupo>/`. Grupos nuevos: agrégalos a `GROUPS` en `core/lazy.lua`.

**Tema heredado de la terminal** (`<leader>S`): lee `alacritty.toml` (Linux, Windows o WSL en `/mnt/*/Users/*/AppData`), resuelve sus `import` y genera un tema de base46 (`lua/themes/terminal.lua`) con el fondo exacto de la terminal, grises interpolados y acentos con contraste mínimo (`theme.terminal.min_contrast`). Se recuerda entre sesiones (estado en `stdpath("state")/appearance.json` + marcador junto a la caché de base46) y se sigue EN VIVO: mientras el tema activo es el terminal, un sondeo (`theme.terminal.watch_ms`, 1000 ms; 0 = apagado) hace `stat` de los archivos de la config y recompila al detectar un cambio (inotify no sirve: en WSL la config está en `/mnt/c`). Con el tema por defecto no corre nada. También re-sincroniza al abrir nvim y al volver el foco. Ruta personalizada: `theme.terminal.config`.

**Ajustes por máquina**: `lua/local.lua` (ignorado por git) devuelve una tabla parcial que se mezcla sobre `core/settings.lua` (tema, lenguajes desactivados, format-on-save, opciones de vim, clipboard, modo ligero...). Ejemplo: `return { languages = { disabled = { "astro" } } }`.

## Key tools included

| Category | Tools |
|----------|-------|
| LSP | gopls, vtsls, tailwindcss, eslint, jsonls+schemastore, prismals, dockerls, astro |
| Formatters | stylua, goimports+gofumpt, prettier, dart_format |
| Linters | golangci-lint (govet in light mode), eslint_d, markdownlint, jsonlint, ysc (YarnSpinner) |
| Completion | blink.cmp, mini.pairs |
| Terminal | toggleterm, lazydocker (via TermExec) |
| Navigation | harpoon (<leader>h*), flash.nvim (s/S), aerial (symbol outline), nvim-ufo (folds) |
| UI | lualine, gitsigns, vim-illuminate, render-markdown, todo-comments, nvim-highlight-colors (hex/rgb/Tailwind preview) |
| Other | Telescope+fzf-native, nvim-tree, Trouble, autotag, git-blame, grug-far (<leader>fr global replace), mini.surround, mini.move (Alt+hjkl), neoconf, package-info |

## Performance

- **git-blame** is off by default — toggle with `<leader>Gb` (no `BufRead` overhead)
- **Telescope** respects `.gitignore` in `find_files` (skip `node_modules`, `dist/`, etc.)
- **nvim-tree** hides git-ignored dirs by default — toggle with `I` or `git.ignore = false`
- Plugins are lazy-loaded via events, ft, cmd, or keys (not on startup)

- `ftdetect/yarnspinner.vim` — `*.yarn` → `yarnspinner` filetype
- `syntax/yarnspinner.vim` — syntax highlighting for YarnSpinner dialogue scripts

## Gotchas

- **Clipboard (WSL/SSH sin DISPLAY)**: `core/clipboard.lua` usa OSC 52 para copiar (Alacritty + herdr lo reenvían); pegar desde el sistema es Ctrl+Shift+V en la terminal
- **ysc (YarnSpinner linter)** es opcional: se activa solo si `ysc` está en el PATH (`dotnet tool install -g yarn-spinner`, requiere `dotnet`)
- **`:checkhealth mason`** avisa de ruby/gem/php/java/julia/composer/luarocks ausentes: es solo informativo, ningún tool de la config los necesita
- **Menús contextuales del leader** (`lua/menus/` + campo `menu` de cada lenguaje): cada lenguaje tiene su letra y solo existe en buffers de ese filetype (g Go, d Dart, r Rust, p Python, t TS/JS, m Markdown, s CSS, j Java, k Kotlin); `<leader>G` Git solo dentro de un repo. Para añadir un lenguaje: nueva entrada en la tabla `langs`. No definas un mapeo que sea a la vez acción y prefijo de otros (p. ej. `<leader>h` + `<leader>h1`): which-key lo resuelve tras `timeoutlen` y cierra el popup
- **Treesitter** compila parsers con el compilador de C del sistema (`gcc`) y requiere el binario `tree-sitter` (`tree-sitter-cli`)
- **No standalone run**: this is a config repo, must be symlinked to Neovim's config path
- **lazy-lock.json** committed for reproducible plugin versions
- `.claude/settings.local.json` is NOT committed (machine-specific permissions)
- **Astro formatting** requires `prettier-plugin-astro` in the project's `node_modules` or installed globally — Mason only installs `prettier` itself
- **mini.surround** keymaps: `sa` add, `sd` delete, `sr` replace surrounding delimiters
- **flash.nvim** keymaps: `s` jump to any word label, `S` jump to treesitter nodes (preserves native `r` replace char)
- **telescope-fzf-native** requires `cmake` installed on the system (auto-disabled if missing via `enabled`)
- **Auto-reload limitation**: `luafile $MYVIMRC` reloads Lua config but does NOT install/remove plugins or treesitter parsers. For plugin changes, use `:Lazy sync` or restart nvim.
- **Light mode** (`nvim/lua/core/light.lua`): auto-detects RAM ≤ 2GB and disables all resident stuff — LSP servers, go.nvim, golangci-lint (falls back to `go vet`). Mason installs only `goimports`+`gofumpt`. Keeps treesitter + conform (ephemeral formatters) + nvim-lint. Override with `NVIM_LIGHT=1|0` env, `settings.light.force` or `vim.g.light_mode`.
