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

| Key | Action |
|-----|--------|
| `<leader>tt` | Toggle float terminal |
| `<leader>gg` | Open lazygit |
| `<leader>gd` | Open lazydocker |
| `<leader>gb` | Toggle git blame inline |
| `<leader>du` | Toggle DAP UI |
| `<leader>xx` | Diagnostics (Trouble) |
| `<leader>xb` | Buffer diagnostics |
| `;` | Command mode |
| `jk` | Escape (insert mode) |
| `<C-LeftMouse>` | Go to definition |
