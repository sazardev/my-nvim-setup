-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "gruvbox",
  theme_toggle = { "gruvbox", "gruvbox_light" },

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    St_gitIcons = { fg = "white", bg = "lightbg", bold = true },
  },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⡲⠃⡰⣆⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⢀⡔⢡⠮⡠⠊⣰⠂⠀⠀",
    "⠀⠀⠀⠀⠀⠀⢀⠎⠠⡧⠊⠀⡠⠁⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⡘⠀⠀⠀⠀⡔⠃⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⣯⣃⣾⡧⠊⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⢀⣿⣿⣥⠀⠀⠀⣀⣤⠾⠷",
    "⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣶⡿⠋⠉⠀⠀",
    "⠀⠀⠀⠀⠈⣻⠿⣿⣿⣿⡿⠛⠃⠀⠀⠀⠀",
    "⠀⠀⣤⣔⠎⠇⠙⠀⢧⢸⠀⠀⠀⠀⠀⠀⠀",
    "⠐⠊⠁⠁⠀⠀⠀⠀⠸⢸⠀⠀⠀⠀⠀⠀⠀",
  },
  buttons = function()
    local git = function(cmd)
      local out = vim.fn.system(cmd):gsub("[\n\r]", "")
      return vim.v.shell_error == 0 and out or ""
    end

    local repo = git "git rev-parse --show-toplevel 2>nul"
    if repo ~= "" then
      repo = vim.fn.fnamemodify(repo, ":t")
    end
    local user = git "git config user.name 2>nul"
    local branch = git "git branch --show-current 2>nul"

    local btns = {}

    -- ── Git info (clean, no icons) ──
    table.insert(btns, { txt = " ", hl = "NvDashFooter", no_gap = true, rep = true })
    if repo ~= "" then
      local line = branch ~= "" and ("  " .. repo .. " (" .. branch .. ")") or ("  " .. repo)
      table.insert(btns, { txt = line, hl = "NvDashFooter", no_gap = true, content = "fit" })
    end
    if user ~= "" then
      table.insert(btns, { txt = "  " .. user, hl = "Comment", no_gap = true, content = "fit" })
    end
    table.insert(btns, { txt = " ", hl = "NvDashFooter", no_gap = true, rep = true })

    -- ── Action buttons ──
    vim.list_extend(btns, {
      { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
      { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
      { txt = "  Find Word", keys = "fw", cmd = "Telescope live_grep" },
      { txt = "  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
      { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },
    })

    return btns
  end,
}
M.ui = {
  statusline = {
    separator_style = "block",
    order = { "mode", "file", "git", "%=", "diagnostics", "lsp", "cwd", "cursor" },
    modules = {
      mode = function()
        local utils = require "nvchad.stl.utils"
        if not utils.is_activewin() then return "" end
        local m = vim.api.nvim_get_mode().mode
        local modes = utils.modes
        local seps = utils.separators.block
        return "%#St_" .. modes[m][2] .. "Mode#  " .. modes[m][1] .. " "
          .. "%#St_" .. modes[m][2] .. "ModeSep#" .. seps.right
          .. "%#ST_EmptySpace#" .. seps.right
      end,
      file = function()
        local utils = require "nvchad.stl.utils"
        local x = utils.file()
        local seps = utils.separators.block
        return "%#St_file#  " .. x[2] .. "  %#St_file_sep#" .. seps.right
      end,
      git = function()
        local buf = vim.api.nvim_get_current_buf()
        local ok, head = pcall(vim.api.nvim_buf_get_var, buf, "gitsigns_head")
        if not ok or not head then return "" end
        return "%#St_file#  " .. head .. " "
      end,
      diagnostics = function()
        local buf = vim.api.nvim_get_current_buf()
        local parts = {}
        local err = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })
        if err > 0 then table.insert(parts, "%#St_lspError#  E:" .. err .. " ") end
        local warn = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.WARN })
        if warn > 0 then table.insert(parts, "%#St_lspWarning#  W:" .. warn .. " ") end
        local info = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.INFO })
        if info > 0 then table.insert(parts, "%#St_LspInfo#  I:" .. info .. " ") end
        local hint = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.HINT })
        if hint > 0 then table.insert(parts, "%#St_LspHints#  H:" .. hint .. " ") end
        return table.concat(parts)
      end,
      lsp = function()
        local buf = vim.api.nvim_get_current_buf()
        if not rawget(vim, "lsp") then return "" end
        for _, client in ipairs(vim.lsp.get_clients()) do
          if client.attached_buffers[buf] then
            return "%#St_Lsp#  " .. client.name .. " "
          end
        end
        return ""
      end,
      cwd = function()
        local utils = require "nvchad.stl.utils"
        local seps = utils.separators.block
        local name = vim.uv.cwd()
        name = "%#St_cwd_text#  " .. (name:match "([^/\\]+)[/\\]*$" or name) .. " "
        return (vim.o.columns > 85 and ("%#St_cwd_sep#" .. seps.left .. name)) or ""
      end,
      cursor = function()
        local utils = require "nvchad.stl.utils"
        local seps = utils.separators.block
        return "%#St_pos_sep#" .. seps.left .. "%#St_pos_text#  %l/%v "
      end,
    },
  },
  tabufline = {
    enabled = false,
  },
}

return M
