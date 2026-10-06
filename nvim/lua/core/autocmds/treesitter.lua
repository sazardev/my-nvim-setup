-- ── Arranque del highlighter de treesitter ───────────────────────────────────
-- La rama "main" de nvim-treesitter ya no lo inicia sola: sin esto ningún
-- capture (@function, @operator...) se resalta aunque el parser esté instalado.
local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
    end,
  })
end

return M
