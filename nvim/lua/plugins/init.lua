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
    dependencies = { "saghen/blink.cmp" },
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
      },
    },
    config = function(_, opts)
      -- La API nueva de nvim-treesitter (rama "main") ya NO instala sola los
      -- parsers listados en ensure_installed dentro de .setup() (a diferencia
      -- de la rama vieja) — hay que pedirlo explícito con .install(). Sin esto
      -- nunca se compila ningún parser y el highlighter nunca tiene nada que
      -- resaltar (aunque .setup() no tira error, queda en silencio). También
      -- requiere el binario `tree-sitter` (paquete `tree-sitter-cli`) instalado
      -- en el sistema, no solo un compilador de C.
      require("nvim-treesitter").setup {}
      require("nvim-treesitter").install(opts.ensure_installed)
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
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
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
    cond = function()
      return not require("configs.resources").light
    end,
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
      "saghen/blink.cmp",
    },
    config = function()
      require "configs.flutter"
    end,
  },



  -- ── Diagnostics panel ─────────────────────────────────────────────────────
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    },
    opts = {},
    config = function(_, opts)
      require("trouble").setup(opts)
    end,
  },

  -- ── Mason: auto-instalar todos los tools ─────────────────────────────────
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = require("configs.resources").light
          -- Modo ligero: solo formatters efímeros; cero LSP/linters residentes
          and { "goimports", "gofumpt" }
        or {
          -- Lua (lua_ls lo habilita NvChad por default)
          "stylua",
          "lua-language-server",
          -- Go
          "gopls",
          "goimports",
          "gofumpt",
          "golangci-lint",
          -- JS / TS / React
          "prettier",
          "eslint_d",
          "vtsls",
          -- Markdown
          "markdownlint-cli2",
          "markdownlint",
          -- Otros
          "jsonlint",
          -- Prisma (schemas multitenancy)
          "prisma-language-server",
          -- Docker (Dockerfile + docker-compose.yml)
          "dockerfile-language-server",
          "docker-compose-language-service",

          -- ESLint LSP (code actions) + JSON LSP (schema validation)
          "eslint-lsp",
          "json-lsp",
          -- Astro
          "astro-language-server",
          -- HTML / CSS / Emmet (vim.lsp.enable en lspconfig.lua)
          "html-lsp",
          "css-lsp",
          "emmet-ls",
          -- Tailwind CSS
          "tailwindcss-language-server",
        },
      auto_update = false,
      run_on_start = false, -- tools ya instalados; no checar versiones en cada arranque
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
        prompt_prefix = "> ",
        selection_caret = "  ",
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

  -- ── Reemplazo global estilo VS Code ───────────────────────────────────────
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      { "<leader>fr", "<cmd>GrugFar<cr>", desc = "replace" },
    },
    opts = {
      keymaps = {
        close = { n = "q" },
      },
    },
    config = function(_, opts)
      require("grug-far").setup(opts)
    end,
  },

  -- ── nvim-tree: oculta git-ignored (rápido), muestra dotfiles, sin íconos ──
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        dotfiles = true,
        git_ignored = true,
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
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "nvim-tree: " .. desc, nowait = true })
        end

        api.config.mappings.default_on_attach(bufnr)

        -- <CR> sobre un archivo → abre y cierra nvim-tree
        map("n", "<CR>", function()
          local node = api.tree.get_node_under_cursor()
          if node.nodes then
            api.node.open.edit()
          else
            api.node.open.edit()
            api.tree.close()
          end
        end, "Open file and close tree")
      end,
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },

  -- ── Autocompletar (blink.cmp: nativo, sin íconos, ultra rápido) ─────────────
  {
    "saghen/blink.cmp",
    version = "1.*", -- v2 (main) requiere blink.lib compilado con Rust
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      -- Tab elige la opción de la lista, Enter la inserta (sin flechas)
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<Up>"] = false,
        ["<Down>"] = false,
      },
      appearance = {
        -- sin íconos de kind (plano, minimalista)
        use_nvim_cmp_as_default = false,
        kind_icons = {},
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          -- flutter.json de friendly-snippets usa el language id "flutter",
          -- que no es un filetype real de Neovim (siempre es "dart") — hay
          -- que pedirlo explícito como extensión de "dart".
          snippets = {
            opts = {
              extended_filetypes = { dart = { "flutter" } },
            },
          },
        },
      },
      completion = {
        list = { selection = { preselect = false } },
        documentation = {
          auto_show = true,
          window = { border = "single" },
        },
      },
      signature = {
        enabled = true,
        window = { border = "single" },
      },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)
    end,
  },

  -- NvChad v2.5 trae su propio stack nvim-cmp + LuaSnip + autopairs;
  -- deshabilitado a favor de blink.cmp (sus deps ya no cargan)
  { "hrsh7th/nvim-cmp", enabled = false },

  -- ── Terminal (lazygit, lazydocker, Go commands) ─────────────────────────────
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
      size = 0.6,
      open_mapping = false,
      direction = "float",
      float_opts = { border = "single" },
      close_on_exit = true,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      -- Esc en terminal cierra la ventana flotante
      vim.keymap.set("t", "<Esc>", "<cmd>lua require('toggleterm').toggle()<cr>", { desc = "Close terminal (Esc)" })
    end,
  },

  -- ── Harpoon: "favoritos" de archivos del ciclo de trabajo ──────────────────
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Add file" },
      { "<leader>h1", function() require("harpoon"):list():select(1) end, desc = "File 1" },
      { "<leader>h2", function() require("harpoon"):list():select(2) end, desc = "File 2" },
      { "<leader>h3", function() require("harpoon"):list():select(3) end, desc = "File 3" },
      { "<leader>h4", function() require("harpoon"):list():select(4) end, desc = "File 4" },
      { "<leader>hm", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Menu" },
    },
    config = function()
      require("harpoon").setup {}
    end,
  },

  -- ── Git blame inline (manual via keymap, sin overhead al abrir archivos) ──
  {
    "f-person/git-blame.nvim",
    cmd = "GitBlameToggle",
    opts = {
      date_format = "%Y-%m-%d %H:%M",
      virtual_text_column = 80,
      enabled = false,
    },
    config = function(_, opts)
      require("gitblame").setup(opts)
    end,
  },

  -- ── Autopairs: auto-cierre de ()[]{} (mini.* = consistente con surround) ──
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },

  -- ── mini.move: mover líneas/bloques con Alt+hjkl ─────────────────────────
  {
    "echasnovski/mini.move",
    keys = {
      { "<A-j>", mode = { "n", "v" }, desc = "Move down" },
      { "<A-k>", mode = { "n", "v" }, desc = "Move up" },
      { "<A-h>", mode = { "n", "v" }, desc = "Move left" },
      { "<A-l>", mode = { "n", "v" }, desc = "Move right" },
    },
    opts = {
      mappings = {
        left = "<A-h>",
        right = "<A-l>",
        down = "<A-j>",
        up = "<A-k>",
      },
    },
    config = function(_, opts)
      require("mini.move").setup(opts)
    end,
  },

  -- ── Surround: añadir/quitar/cambiar delimitadores ────────────────────────
  {
    "echasnovski/mini.surround",
    keys = {
      { "sa", mode = { "n", "x" }, desc = "Add surrounding" },
      { "sd", mode = "n", desc = "Delete surrounding" },
      { "sr", mode = "n", desc = "Replace surrounding" },
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
    opts = {
      float = { border = "single" },
    },
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

  -- ── Preview de colores (hex, rgb, clases Tailwind) inline ─────────────────
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      render = "background",
      enable_named_colors = true,
      enable_tailwind = true,
    },
    config = function(_, opts)
      require("nvim-highlight-colors").setup(opts)
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



  -- ── npm package versions in package.json ────────────────────────────────
  {
    "vuki656/package-info.nvim",
    ft = "json",
    opts = {},
    config = function(_, opts)
      require("package-info").setup(opts)
    end,
  },



  -- ── NvChad overrides (explicit config to bypass lazy auto-detection) ──
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        delay = 0,
        icons = {
          mappings = false,
        },
        spec = {
{ "<leader>f", group = "Find" },
          { "<leader>g", group = "Git" },
          { "<leader>r", group = "go" },
          { "<leader>x", group = "Diagnostics" },
          { "<leader>h", group = "Harpoon" },
          { "<leader>v", hidden = true },
          { "<leader>p", hidden = true },
          { "<leader>q", hidden = true },
          { "<leader>wK", hidden = true },
          { "<leader>wk", hidden = true },
          { "<leader>c", hidden = true },
          { "<leader>o", hidden = true },
          { "<leader>d", hidden = true },
          { "<leader>b", hidden = true },
          { "<leader>s", hidden = true },
          { "<leader>m", hidden = true },
          { "<leader>n", hidden = true },
          -- keymaps disabled dentro de grupos visibles
          { "<leader>fa", hidden = true },
          { "<leader>fz", hidden = true },
          { "<leader>fh", hidden = true },
          { "<leader>fc", hidden = true },
          { "<leader>gb", hidden = true },
          { "<leader>gd", hidden = true },
          { "<leader>rn", hidden = true },
          { "<leader>xb", hidden = true },
        },
      }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signcolumn = false,   -- sin signs en signcolumn
      numhl = true,         -- número de línea cambia de color (gruvbox)
      linehl = false,       -- sin highlight en la línea entera
      current_line_blame = false,
      update_debounce = 100, -- debounce = menos redraws
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



  -- ── Project-local LSP config (.neoconf.json) ──────────────────────────────────
  {
    "folke/neoconf.nvim",
    event = "BufReadPre",
    opts = {},
    config = function(_, opts)
      require("neoconf").setup(opts)
    end,
  },

  -- ── lualine.nvim (reemplaza el statusline custom de NvChad) ──────────────────
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        -- theme se resuelve en config() leyendo base46 de NvChad,
        -- así cambia si el usuario usa theme_toggle (gruvbox <-> gruvbox_light)
        theme = "auto",
        section_separators = "",
        component_separators = "",
        globalstatus = true,
        refresh = {
          statusline = 200,
          winbar = 200,
          tabline = 200,
          underline = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "filename" },
        lualine_c = { { "branch", icon = "" } },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = "E", warn = "W" },
            diagnostics_color = {
              error = "DiagnosticError",
              warn = "DiagnosticWarn",
            },
            colored = true,
            sections = { "error", "warn" },
          },
        },
        lualine_y = {
          {
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients == 0 then return "" end
              return table.concat(
                vim.tbl_map(function(c) return c.name end, clients),
                " "
              )
            end,
            cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end,
          },
          {
            function()
              local name = vim.uv.cwd()
              return name:match("([^/\\]+)[/\\]*$") or name
            end,
            cond = function() return vim.o.columns > 85 end,
          },
        },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = { "filename" },
        lualine_c = {},
        lualine_x = { "filetype" },
        lualine_y = {},
        lualine_z = { "location" },
      },
    },
    config = function(_, opts)
      local function build_theme()
        local ok, base46 = pcall(require, "base46")
        if not ok then
          return require("lualine.themes.gruvbox_dark")
        end
        local p30 = base46.get_theme_tb("base_30") or {}
        local p16 = base46.get_theme_tb("base_16") or {}
        local is_dark = base46.get_theme_tb("type") ~= "light"

        local mode_fg = p16.base00 or "#282828"
        local c_bg = is_dark and (p30.statusline_bg or "#2c2c2c") or (p16.base01 or "#3c3836")
        local c_fg = p16.base04 or "#bdae93"
        local b_bg = p30.lightbg or p16.base01 or "#3d3d3d"
        local b_fg = p30.white or p16.base06 or "#ebdbb2"
        local inactive_a = is_dark and (p30.one_bg2 or "#3f3f3f") or (p16.base02 or "#423e3c")

        local modes = {
          normal   = p30.nord_blue or "#83a598",
          insert   = p30.green or "#b8bb26",
          visual   = p30.sun or "#fabd2f",
          replace  = p30.red or "#fb4934",
          command  = p30.dark_purple or "#d3869b",
          terminal = p30.orange or "#e78a4e",
        }

        local function section(m)
          return {
            a = { bg = modes[m], fg = mode_fg, gui = "bold" },
            b = { bg = b_bg, fg = b_fg },
            c = { bg = c_bg, fg = c_fg },
          }
        end

        return {
          normal   = section("normal"),
          insert   = section("insert"),
          visual   = section("visual"),
          replace  = section("replace"),
          command  = section("command"),
          terminal = section("terminal"),
          inactive = {
            a = { bg = inactive_a, fg = c_fg, gui = "bold" },
            b = { bg = inactive_a, fg = c_fg },
            c = { bg = c_bg, fg = c_fg },
          },
        }
      end

      opts.options.theme = build_theme()
      require("lualine").setup(opts)

      -- Re-aplica el theme si NvChad recarga colores (p.ej. theme_toggle)
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("LualineNvChadTheme", { clear = true }),
        callback = function()
          local ok, lualine = pcall(require, "lualine")
          if ok then
            lualine.setup({ options = { theme = build_theme() } })
          end
        end,
      })
    end,
  },
}
