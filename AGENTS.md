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
- LSP servers and tools (gopls, vtsls, stylua, prettier, eslint_d, dart, etc.) auto-install via `mason-tool-installer`
- No manual setup beyond the symlink
- **Auto-reload**: `.githooks/post-merge` creates a marker on `git pull`; `autocmds.lua` detects it on `UIEnter` and runs `luafile $MYVIMRC` to reload config automatically

## Key tools included

| Category | Tools |
|----------|-------|
| LSP | gopls, vtsls, tailwindcss, eslint, jsonls+schemastore, prismals, dockerls, astro |
| Formatters | stylua, goimports+gofumpt, prettier, dart_format |
| Linters | golangci-lint, eslint_d, markdownlint, jsonlint, ysc (YarnSpinner) |
| Debug | nvim-dap, nvim-dap-go, nvim-dap-ui |
| Terminal | toggleterm, lazygit, lazydocker (via TermExec) |
| Other | Telescope, nvim-tree, Copilot+cmp, Trouble, fidget, autotag, rest.nvim, git-blame, treesitter-context, mini.surround, dressing, vim-illuminate, mini.indentscope, flash.nvim |

## Performance

- **git-blame** is off by default — toggle with `<leader>gb` (no `BufRead` overhead)
- **Telescope** respects `.gitignore` in `find_files` (skip `node_modules`, `dist/`, etc.)
- **nvim-tree** hides git-ignored dirs by default — toggle with `I` or `git.ignore = false`
- Plugins are lazy-loaded via events, ft, cmd, or keys (not on startup)

- `ftdetect/yarnspinner.vim` — `*.yarn` → `yarnspinner` filetype
- `syntax/yarnspinner.vim` — syntax highlighting for YarnSpinner dialogue scripts

## Gotchas

- **Windows-only config**: paths assume Windows, uses `gcc` for treesitter (avoids MSVC)
- **No standalone run**: this is a config repo, must be symlinked to Neovim's config path
- **lazy-lock.json** committed for reproducible plugin versions
- `.claude/settings.local.json` is NOT committed (machine-specific permissions)
- **Astro formatting** requires `prettier-plugin-astro` in the project's `node_modules` or installed globally — Mason only installs `prettier` itself
- **rest.nvim** uses `.http` files — write requests and run them inline (httpie alternative inside Neovim)
- **mini.surround** keymaps: `sa` add, `sd` delete, `sr` replace surrounding delimiters
- **flash.nvim** keymaps: `s` jump to any word label, `S` jump to treesitter nodes (preserves native `r` replace char)
- **Auto-reload limitation**: `luafile $MYVIMRC` reloads Lua config but does NOT install/remove plugins or treesitter parsers. For plugin changes, use `:Lazy sync` or restart nvim.
