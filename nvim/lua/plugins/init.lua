return {
  -- ── Formatters ────────────────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  -- ── LSP ───────────────────────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- ── Treesitter ────────────────────────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css",
        "javascript", "typescript", "tsx",
        "prisma", "dockerfile", "dotenv",
        "go", "gomod", "gosum", "gowork",
        "json", "yaml", "toml", "markdown",
        "dart",
        -- Astro
        "astro",
      },
    },
    init = function()
      -- Forzar gcc en Windows (evita buscar cl.exe/MSVC)
      require("nvim-treesitter.install").compilers = { "gcc" }
    end,
  },

  -- ── Linting ───────────────────────────────────────────────────────────────
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    config = function()
      require "configs.lint"
    end,
  },

  -- ── Go ────────────────────────────────────────────────────────────────────
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    ft = { "go", "gomod", "gowork" },
    build = ':lua require("go.install").update_all_sync()',
    config = function()
      require("go").setup()
    end,
  },

  -- ── Flutter / Dart ────────────────────────────────────────────────────────
  {
    "akinsho/flutter-tools.nvim",
    ft = { "dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require "configs.flutter"
    end,
  },

  -- ── Debugging ─────────────────────────────────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    lazy = true,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      require("dap-go").setup()
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    keys = { { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" } },
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },

  -- ── Diagnostics panel ─────────────────────────────────────────────────────
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
    },
    opts = {},
  },

  -- ── LSP progress indicator ────────────────────────────────────────────────
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },

  -- ── Mason: auto-instalar todos los tools ─────────────────────────────────
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- Lua
        "stylua",
        -- Go
        "goimports", "gofumpt", "golangci-lint",
        -- JS / TS / React
        "prettier", "eslint_d",
        -- Markdown
        "markdownlint-cli2",
        -- Otros
        "jsonlint",
        -- Prisma (schemas multitenancy)
        "prisma-language-server",
        -- Docker (Dockerfile + docker-compose.yml)
        "dockerfile-language-server",
        "docker-compose-language-service",
        -- Dart / Flutter
        "dart-debug-adapter",
        -- ESLint LSP (code actions) + JSON LSP (schema validation)
        "eslint-lsp",
        "json-lsp",
        -- Astro
        "astro-language-server",
      },
      auto_update = false,
      run_on_start = true,
    },
  },

  -- ── SchemaStore (schemas para JSON LSP: tsconfig, package.json, etc.) ──────
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- ── Auto-cierre y renombrado de tags JSX/HTML ─────────────────────────────
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- ── Telescope: mostrar archivos ignorados por git (.env, etc.) ───────────
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = true,
          no_ignore_parent = true,
        },
      },
    },
  },

  -- ── nvim-tree: mostrar archivos ignorados por git ─────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = {
        ignore = false,
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
      },
    },
  },

  -- ── GitHub Copilot ────────────────────────────────────────────────────────
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false }, -- usamos cmp, no ghost text
      panel = { enabled = false },
      filetypes = {
        ["*"] = true, -- activar en todos los tipos de archivo
      },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "zbirenbaum/copilot-cmp" },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, 1, {
        name = "copilot",
        group_index = 1,
        priority = 100,
      })
      return opts
    end,
  },

  -- ── Terminal (lazygit, lazydocker, etc.) ───────────────────────────────────
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>tt", function() require("toggleterm").toggle() end, desc = "Toggle float terminal" },
    },
    opts = {
      size = 0.6,
      open_mapping = false,
      direction = "float",
    },
  },

  -- ── lazygit integration ────────────────────────────────────────────────────
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open lazygit" },
      { "<leader>gd", "<cmd>TermExec cmd=lazydocker<cr>", desc = "Open lazydocker" },
    },
    dependencies = { "akinsho/toggleterm.nvim" },
  },

  -- ── HTTP requests (httpie alternativa) ─────────────────────────────────────
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- ── Git blame inline ─────────────────────────────────────────────────────
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    opts = {
      date_format = "%Y-%m-%d %H:%M",
      virtual_text_column = 80,
    },
  },
}
