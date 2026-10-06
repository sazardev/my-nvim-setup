return {
  filetypes = { "dockerfile" },
  treesitter = { "dockerfile" },
  lsp = { "dockerls", "docker_compose_language_service" },
  mason = { full = { "dockerfile-language-server", "docker-compose-language-service" } },
}
