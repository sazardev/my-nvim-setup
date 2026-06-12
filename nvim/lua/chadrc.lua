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
    separator_style = "round",
    order = { "mode", "file", "git", "%=", "diagnostics", "lsp", "cwd", "cursor" },
  },
  tabufline = {
    lazyload = false,
    position = "top",
  },
}

return M
