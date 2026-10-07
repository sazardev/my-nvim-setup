-- Diff de varios archivos e historial (por archivo o de todo el repo).
-- Solo carga al invocar un comando; los atajos viven en el menú <leader>G (menus/git.lua).
return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles", "DiffviewRefresh" },
	opts = {
		enhanced_diff_hl = true, -- resalta mejor las líneas añadidas/borradas
	},
	config = function(_, opts)
		require("diffview").setup(opts)
	end,
}
