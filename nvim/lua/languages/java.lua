return {
  filetypes = { "java" },
  treesitter = { "java" },
  menu = { name = "Java", prefix = "j", maps = require "languages.actions.jvm" },
}
