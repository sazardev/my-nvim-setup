return {
  -- ── Formatters ────────────────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
    config = function(_, opts)
      require("conform").setup(opts)
    end,
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
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "prisma",
        "dockerfile",
        "dotenv",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "json",
        "yaml",
        "toml",
        "markdown",
        "dart",
        -- Astro
        "astro",
        -- rest.nvim (parser HTTP)
        "http",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
    init = function()
      -- Forzar gcc en Windows (evita buscar cl.exe/MSVC)
      require("nvim-treesitter.install").compilers = { "gcc" }
    end,
  },
  -- ── Treesitter textobjects (saltar entre funciones, clases, etc.) ─────────
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufReadPost",
    opts = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]c"] = "@class.outer",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[c"] = "@class.outer",
        },
      },
    },
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
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle DAP UI",
      },
    },
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup({
        icons = {
          expanded = " ",
          collapsed = " ",
          current_frame = "*",
        },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 0.25,
            position = "bottom",
          },
        },
        floating = {
          border = "single",
          mappings = { close = { "q", "<Esc>" } },
        },
        windows = { indent = 1 },
      })
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
    config = function(_, opts)
      require("trouble").setup(opts)
    end,
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
        "goimports",
        "gofumpt",
        "golangci-lint",
        -- JS / TS / React
        "prettier",
        "eslint_d",
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
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
    end,
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
    config = function(_, opts)
      require("nvim-ts-autotag").setup(opts)
    end,
  },

  -- ── Telescope: respeta .gitignore, sin íconos en resultados ───────────────
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
        enabled = vim.fn.executable "cmake" == 1,
      },
    },
    opts = {
      defaults = {
        path_display = { "truncate" },
        prompt_prefix = " ",
        selection_caret = " ",
        layout_config = {
          width = 0.9,
          height = 0.9,
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          entry_maker = require("configs.telescope").no_icons(),
          find_command = {
            "rg", "--files", "--hidden", "--no-ignore",
            "--glob", "!.git",
            "--glob", "!node_modules",
            "--glob", "!.next",
            "--glob", "!dist",
            "--glob", "!build",
            "--glob", "!vendor",
            "--glob", "!target",
            "--glob", "!.cache",
            "--glob", "!.nuxt",
            "--glob", "!coverage",
          },
        },
        buffers = {
          entry_maker = require("configs.telescope").no_icons(),
        },
        oldfiles = {
          entry_maker = require("configs.telescope").no_icons(),
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
    end,
  },

  -- ── nvim-tree: oculta git-ignored (rápido), muestra dotfiles, sin íconos ──
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = {
        ignore = true,
      },
      filters = {
        dotfiles = false,
        git_ignored = true,
      },
      view = {
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
            git = false,
          },
        },
      },
      renderer = {
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
            git = false,
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
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
    config = function(_, opts)
      require("copilot").setup(opts)
    end,
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
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  -- ── Terminal (lazygit, lazydocker, etc.) ───────────────────────────────────
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      {
        "<leader>tt",
        function()
          require("toggleterm").toggle()
        end,
        desc = "Toggle float terminal",
      },
    },
    opts = {
      size = 0.6,
      open_mapping = false,
      direction = "float",
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
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
    build = false, -- evitar LuaRocks (tree-sitter-http falla en Windows)
    opts = {},
    config = function(_, opts)
      require("rest-nvim").setup(opts)
    end,
  },

  -- ── Git blame inline (manual via keymap, sin overhead al abrir archivos) ──
  {
    "f-person/git-blame.nvim",
    cmd = "GitBlameToggle",
    keys = {
      { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle git blame" },
    },
    opts = {
      date_format = "%Y-%m-%d %H:%M",
      virtual_text_column = 80,
      enabled = false,
    },
    config = function(_, opts)
      require("gitblame").setup(opts)
    end,
  },

  -- ── Surround: añadir/quitar/cambiar delimitadores ────────────────────────
  {
    "echasnovski/mini.surround",
    keys = {
      { "sa", mode = { "n", "x" }, desc = "Add surrounding" },
      { "sd", mode = "n", desc = "Delete surrounding" },
      { "sr", mode = "n", desc = "Replace surrounding" },
      { "sh", mode = "n", desc = "Highlight surrounding" },
      { "sF", mode = "n", desc = "Find right surrounding" },
      { "sf", mode = "n", desc = "Find left surrounding" },
      { "sn", mode = "n", desc = "Update n_lines" },
    },
    opts = {
      mappings = {
        add = "sa",
        delete = "sd",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "sr",
        update_n_lines = "sn",
      },
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },

  -- ── UI pulida para vim.ui.select/input (LSP rename, code actions) ────────
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("dressing").setup(opts)
    end,
  },

  -- ── Highlight word under cursor (ilumina todas las ocurrencias) ──────────
  {
    "RRethy/vim-illuminate",
    event = { "CursorHold", "CursorHoldI" },
    opts = {
      delay = 200,
      filetypes_denylist = { "NvimTree", "TelescopePrompt", "alpha", "dashboard", "lazy", "mason", "nvdash" },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  -- ── Flash: salto rápido con s/S (no sobrescribe r/R) ──────────────────────
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      {
        "s",
        function()
          require("flash").jump()
        end,
        mode = { "n", "x", "o" },
        desc = "Flash jump",
      },
      {
        "S",
        function()
          require("flash").treesitter()
        end,
        mode = { "n", "x", "o" },
        desc = "Flash treesitter",
      },
    },
    opts = {
      modes = {
        char = { enabled = false },
      },
    },
    config = function(_, opts)
      require("flash").setup(opts)
    end,
  },

  -- ── Test runner inline (Go: go test, etc.) ──────────────────────────────
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      {
        "nvim-neotest/neotest-go",
        ft = "go",
      },
    },
    keys = {
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Run nearest test",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand "%")
        end,
        desc = "Run test file",
      },
      {
        "<leader>ts",
        function()
          require("neotest").run.run { suite = true }
        end,
        desc = "Run test suite",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run last test",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open()
        end,
        desc = "Show test output",
      },
      {
        "<leader>tX",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop tests",
      },
      {
        "<leader>tw",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle test summary",
      },
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-go",
        },
      }
    end,
  },

  -- ── npm package versions in package.json ────────────────────────────────
  {
    "vuki656/package-info.nvim",
    ft = "json",
    opts = {},
    config = function(_, opts)
      require("package-info").setup(opts)
    end,
  },

  -- ── Task runner: go build, npm run dev, docker compose... ────────────────
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerBuild" },
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle task list" },
      { "<leader>ow", "<cmd>OverseerWatch<cr>", desc = "Watch task output" },
    },
    opts = {
      strategy = "toggleterm",
    },
    config = function(_, opts)
      require("overseer").setup(opts)
    end,
  },

  -- ── NvChad overrides (explicit config to bypass lazy auto-detection) ──
  {
    "folke/which-key.nvim",
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = false,        -- sin +/- en signcolumn
      numhl = true,         -- número de línea cambia de color (gruvbox)
      linehl = false,       -- sin highlight en la línea entera
      wordhl = false,       -- sin highlight de palabras cambiadas
      current_line_blame = false,
      update_defer = 100,   -- debounce = menos redraws
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },
  {
    "mason-org/mason.nvim",
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },

  -- ── TODO / FIXME / HACK highlighting + Telescope search ─────────────────────
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true,
      signs_priority = 8,
      keywords = {
        FIX = { icon = "!", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = "T", color = "info" },
        HACK = { icon = "H", color = "warning" },
        WARN = { icon = "W", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "P", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "N", color = "hint", alt = { "INFO" } },
        TEST = { icon = "X", color = "error", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = { fg = "NONE", bg = "NONE", bold = true },
      merge_keywords = true,
      highlight = { multiline = true, multiline_pattern = "^.", multiline_context = 10 },
      search = { command = "rg", pattern = [[\b(KEYWORDS):]] },
    },
    config = function(_, opts)
      require("todo-comments").setup(opts)
    end,
  },



  -- ── Semantic folding (treesitter + indent, sin LSP extra) ───────────────────
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
    config = function(_, opts)
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require("ufo").setup(opts)
    end,
  },

  -- ── Symbol outline sidebar (treesitter + LSP) ──────────────────────────────
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen", "AerialNavToggle" },
    keys = {
      { "<leader>oa", "<cmd>AerialToggle<cr>", desc = "Toggle symbol outline" },
      { "<leader>oA", "<cmd>AerialNavToggle<cr>", desc = "Toggle outline nav" },
    },
    opts = {
      backends = { "treesitter", "lsp", "markdown" },
      layout = { min_width = 30, max_width = 50 },
      show_guides = false,           -- sin líneas verticales
      guide_style = "stub",
      close_behavior = "auto",
      -- Kinds vacíos: íconos de Function/Class/etc. son string vacío
      kinds = {
        File = "", Module = "", Namespace = "", Package = "",
        Class = "", Method = "", Property = "", Field = "",
        Constructor = "", Enum = "", Interface = "", Function = "",
        Variable = "", Constant = "", String = "", Number = "",
        Boolean = "", Array = "", Object = "", Key = "", Null = "",
        EnumMember = "", Struct = "", Event = "", Operator = "",
        TypeParameter = "",
      },
      keymaps = {
        ["<CR>"] = "actions.jump",
        ["<C-s>"] = "actions.jump_vsplit",
        ["<C-v>"] = "actions.jump_split",
        ["q"] = "actions.close",
      },
    },
    config = function(_, opts)
      require("aerial").setup(opts)
    end,
  },

  -- ── Rich Markdown rendering ──────────────────────────────────────────────────
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {},
    config = function(_, opts)
      require("render-markdown").setup(opts)
    end,
  },

  -- ── Harpoon: quick file marks ────────────────────────────────────────────────
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Add file to harpoon",
      },
      {
        "<leader>hm",
        function()
          require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end,
        desc = "Harpoon menu",
      },
      {
        "<A-1>",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon file 1",
      },
      {
        "<A-2>",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon file 2",
      },
      {
        "<A-3>",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon file 3",
      },
      {
        "<A-4>",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon file 4",
      },
    },
    config = function(_, opts)
      require("harpoon").setup(opts)
    end,
  },

  -- ── Project-local LSP config (.neoconf.json) ──────────────────────────────────
  {
    "folke/neoconf.nvim",
    event = "BufReadPre",
    opts = {},
    config = function(_, opts)
      require("neoconf").setup(opts)
    end,
  },

  -- ── Clipboard history (Telescope) ──────────────────────────────────────────────
  {
    "AckslD/nvim-neoclip.lua",
    keys = {
      {
        "<leader>fc",
        function()
          require("telescope").extensions.neoclip.default()
        end,
        desc = "Clipboard history",
      },
    },
    dependencies = {
      { "kkharji/sqlite.lua", module = "sqlite" },
      { "nvim-telescope/telescope.nvim" },
    },
    opts = {
      history = 1000,
      enable_persistent_history = true,
      length_limit = 1048576,
      continuous_sync = true,
      db_path = vim.fn.stdpath "data" .. "/neoclip/db.sqlite3",
    },
    config = function(_, opts)
      require("neoclip").setup(opts)
      require("telescope").load_extension "neoclip"
    end,
  },

  -- ── Session persistence (guardar/restaurar sesión por proyecto) ────────────────
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore last session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").save()
        end,
        desc = "Save current session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't save current session",
      },
    },
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      need = 1,
      branch = true,
    },
    config = function(_, opts)
      require("persistence").setup(opts)
    end,
  },

  -- ── Visual sorting ────────────────────────────────────────────────────────────
  {
    "sQVe/sort.nvim",
    keys = {
      { "<leader>qs", "<cmd>Sort<cr>", mode = "v", desc = "Sort selection" },
    },
    opts = {},
    config = function(_, opts)
      require("sort").setup(opts)
    end,
  },
}
