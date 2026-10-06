-- ── Contexto Git: solo en archivos que viven dentro de un repositorio ────────
local ex = require("utils.actions").ex

return {
  name = "Git",
  prefix = "G",
  detect = function(buf)
    return vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" and vim.fs.root(buf, ".git") ~= nil
  end,
  maps = {
    { "t", "status", ex "Telescope git_status" },
    { "b", "blame toggle", ex "GitBlameToggle" },
  },
}
