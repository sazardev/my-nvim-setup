-- Autocompletar: nativo, sin íconos, ultra rápido.
return {
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
      -- lazydev solo existe en archivos Lua (completa require() y módulos de plugins)
      per_filetype = { lua = { "lazydev", "lsp", "path", "snippets", "buffer" } },
      providers = {
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        -- flutter.json de friendly-snippets usa el language id "flutter", que no
        -- es un filetype real de Neovim (siempre es "dart"): se pide explícito.
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
}
