-- Deja fija arriba la línea de la función/clase/bloque actual al hacer scroll.
-- Reutiliza el árbol de treesitter (sin parseo extra); `:TSContext toggle` lo apaga.
return {
	"nvim-treesitter/nvim-treesitter-context",
	event = { "BufReadPost", "BufNewFile" },
	cmd = "TSContext",
	opts = {
		max_lines = 3, -- como mucho 3 líneas fijas: no se come la pantalla
		multiline_threshold = 1, -- firmas largas: solo la primera línea
		trim_scope = "outer", -- si hay más de max_lines, descarta los ámbitos externos
	},
	config = function(_, opts)
		require("treesitter-context").setup(opts)
	end,
}
