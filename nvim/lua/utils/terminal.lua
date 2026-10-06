-- ── Terminal flotante (toggleterm) ───────────────────────────────────────────
local M = {}

--- Ejecuta `cmd` en un terminal flotante con cwd `dir`
---@param cmd string
---@param dir string
function M.float(cmd, dir)
  vim.cmd(("TermExec cmd=%s dir=%s direction=float"):format(vim.fn.shellescape(cmd), vim.fn.shellescape(dir)))
end

return M
