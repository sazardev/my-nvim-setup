-- Blame inline: desactivado por defecto, se alterna con <leader>Gb (sin overhead en BufRead)
return {
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
}
