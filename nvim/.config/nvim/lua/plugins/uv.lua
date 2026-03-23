return {
	{
		"benomahony/uv.nvim",
		opts = {}, -- Accepts all default options
		config = function(_, opts)
			require("uv").setup(opts)
		end,
	},
}
