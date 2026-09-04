require("nvchad.configs.lspconfig").defaults()

-- ── blink.cmp: inyectar sus capabilities a todos los clientes LSP ──────────
-- NvChad ya definió vim.lsp.config("*") con capabilities + on_init (apaga
-- semantic tokens). Tomamos sus capabilities como base y forzamos las de
-- blink encima, preservando on_init.
local base = vim.lsp.config["*"]
vim.lsp.config("*", {
  capabilities = vim.tbl_deep_extend(
    "force",
    base.capabilities,
    require("blink.cmp").get_lsp_capabilities({}, false)
  ),
  on_init = base.on_init,
})

-- ── Keymaps LSP extra (NvChad v2.5 no mapea code actions) ───────────────────
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
      buffer = args.buf,
      desc = "LSP code action",
    })
  end,
})

-- ── Servidores simples (sin config extra) ────────────────────────────────────
vim.lsp.enable { "html", "cssls", "emmet_ls" }

-- ── Go ────────────────────────────────────────────────────────────────────────
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
      directoryFilters = { "-**/node_modules", "-**/vendor", "-**/.git" },
      analyses = {
        unusedparams = true,
        shadow = true,
        unusedwrite = true,
        useany = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})
vim.lsp.enable "gopls"

-- ── TypeScript / JavaScript / React ──────────────────────────────────────────
vim.lsp.config("vtsls", {
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "literals" },
        variableTypes = { enabled = true },
        returnTypes = { enabled = true },
      },
    },
    javascript = {
      inlayHints = {
        parameterNames = { enabled = "literals" },
      },
    },
  },
})
vim.lsp.enable "vtsls"

-- ── Prisma ───────────────────────────────────────────────────────────────────
vim.lsp.enable "prismals"

-- ── Docker ───────────────────────────────────────────────────────────────────
vim.lsp.enable "dockerls"
vim.lsp.enable "docker_compose_language_service"

-- ── Tailwind CSS ─────────────────────────────────────────────────────────────
vim.lsp.config("tailwindcss", {
  filetypes = {
    "html", "css",
    "javascript", "javascriptreact",
    "typescript", "typescriptreact",
  },
})
vim.lsp.enable "tailwindcss"

-- ── ESLint LSP (code actions + auto-fix con <leader>ca) ──────────────────────
vim.lsp.config("eslint", {
  settings = {
    workingDirectories = { mode = "auto" },
  },
})
vim.lsp.enable "eslint"

-- ── JSON LSP con SchemaStore (tsconfig, package.json, nest-cli, etc.) ────────
vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
  on_new_config = function(config)
    config.settings.json.schemas = config.settings.json.schemas or {}
    vim.list_extend(config.settings.json.schemas, require("schemastore").json.schemas())
  end,
})
vim.lsp.enable "jsonls"

-- ── Astro ────────────────────────────────────────────────────────────────────
vim.lsp.config("astro", {
  filetypes = { "astro" },
})
vim.lsp.enable "astro"
