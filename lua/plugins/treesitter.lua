return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"c",
				"lua",
				"vimdoc",
				"javascript",
				"css",
				"scss",
				"html",
				"python",
				"html",
				"latex",
				"java",
			},
		},
		config = function(_, opts)
			-- install parser from opts
			if opts.ensure_installed and #opts.ensure_installed > 0 then
				require("nvim-treesitter").install(opts.ensure_installed)
				-- Enable the parser
				for _, parser in ipairs(opts.ensure_installed) do
					local filetype = parser
					vim.treesitter.language.register(parser, filetype) -- not sure why this is needed

					vim.api.nvim_create_autocmd({ "FileType" }, {
						pattern = filetype,
						callback = function(event)
							vim.treesitter.start(event.buf, parser)
						end,
					})
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end
		end,
	},
}
