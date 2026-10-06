-- ── Keymaps y etiquetas extra al adjuntar un servidor LSP ────────────────────
local M = {}

--- Nombra el grupo <leader>r (NvChad: <leader>ra = renamer) salvo que el buffer
--- ya tenga un menú contextual con ese prefijo (p. ej. Rust).
local function label_rename_group(buf)
  if (vim.b[buf].menu_contexts or {}).r then
    return
  end
  local ok, wk = pcall(require, "which-key")
  if ok then
    wk.add { { "<leader>r", group = "Rename", buffer = buf } }
  end
end

function M.setup()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspExtraKeymaps", { clear = true }),
    callback = function(args)
      -- NvChad v2.5 no mapea code actions
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
        buffer = args.buf,
        desc = "LSP code action",
      })
      label_rename_group(args.buf)
    end,
  })
end

return M
