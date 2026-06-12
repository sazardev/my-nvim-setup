-- Flutter-tools.nvim config
-- Docs: https://github.com/akinsho/flutter-tools.nvim

-- Capabilities: usar las de nvim-cmp si están disponibles
local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  pcall(require, "cmp_nvim_lsp") and require("cmp_nvim_lsp").default_capabilities() or {}
)

require("flutter-tools").setup {
  -- ── UI ──────────────────────────────────────────────────────────────────────
  ui = {
    border = "rounded",
    notification_style = "native",
  },

  -- ── Decoraciones en el buffer ────────────────────────────────────────────────
  decorations = {
    statusline = {
      app_version = true,   -- muestra versión de la app en statusline
      device = true,        -- muestra el dispositivo activo
    },
  },

  -- ── Widget guides: guías visuales para widgets anidados ──────────────────────
  widget_guides = {
    enabled = true,
  },

  -- ── Closing tags virtuales ────────────────────────────────────────────────────
  -- Muestra `// ClassName` al final del paréntesis de cierre
  closing_tags = {
    highlight = "Comment",
    prefix    = " // ",
    enabled   = true,
  },

  -- ── Dev log ───────────────────────────────────────────────────────────────────
  dev_log = {
    enabled = true,
    filter  = nil,
    open_cmd = "tabedit",
  },

  -- ── Flutter run ───────────────────────────────────────────────────────────────
  flutter_path = nil,    -- auto-detect desde PATH
  flutter_lookup_cmd = nil,

  -- ── LSP (Dart Language Server) ────────────────────────────────────────────────
  lsp = {
    color = {
      enabled    = true,    -- usa colores de tipo en Dart
      background = false,   -- sin fondo de color (puede ser molesto)
      foreground = false,
      virtual_text = true,
      virtual_text_str = "■",
    },
    capabilities = capabilities,
    settings = {
      dart = {
        completeFunctionCalls          = true,
        showTodos                      = true,
        analysisExcludedFolders        = { ".dart_tool", ".pub-cache" },
        renameFilesWithClasses         = "prompt",
        enableSnippets                 = true,
        updateImportsOnRename          = true,
      },
    },
  },

  -- ── Debugger (nvim-dap) ────────────────────────────────────────────────────
  debugger = {
    enabled = true,
    run_via_dap = true,
    register_configurations = function(_)
      require("dap").configurations.dart = {}
      require("dap.ext.vscode").load_launchjs()
    end,
  },
}
