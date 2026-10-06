-- ── Componentes de lualine ───────────────────────────────────────────────────
local M = {}

---@return string nombres de los clientes LSP del buffer
function M.lsp_clients()
  local names = vim.tbl_map(function(client)
    return client.name
  end, vim.lsp.get_clients { bufnr = 0 })
  return table.concat(names, " ")
end

---@return boolean
function M.has_lsp()
  return #vim.lsp.get_clients { bufnr = 0 } > 0
end

---@return string nombre de la carpeta de trabajo
function M.project_name()
  local cwd = vim.uv.cwd() or ""
  return cwd:match "([^/\\]+)[/\\]*$" or cwd
end

---@return boolean
function M.is_wide()
  return vim.o.columns > 85
end

return M
