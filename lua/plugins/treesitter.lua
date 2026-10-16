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
				"latex",
				"java",
				"sql",
				-- tsx parser is used for .tsx files (and covers JSX syntax)
				"tsx",
			},
		},
		config = function(_, opts)
			-- install parser from opts
			if opts.ensure_installed and #opts.ensure_installed > 0 then
				require("nvim-treesitter").install(opts.ensure_installed)
			end

			-- Filetypes whose treesitter language differs from their filetype name
			-- (.jsx uses the plain "javascript" parser, which supports JSX)
			local parser_by_ft = {
				typescriptreact = "tsx",
				javascriptreact = "javascript",
			}

			-- keep the same register calls as before, extended to the react filetypes
			for _, parser in ipairs(opts.ensure_installed or {}) do
				vim.treesitter.language.register(parser, parser) -- not sure why this is needed
			end
			for ft, parser in pairs(parser_by_ft) do
				vim.treesitter.language.register(parser, ft) -- not sure why this is needed
			end

			-- list of every filetype that should get a treesitter parser
			local fts = {}
			for ft, _ in pairs(parser_by_ft) do
				table.insert(fts, ft)
			end
			for _, parser in ipairs(opts.ensure_installed or {}) do
				table.insert(fts, parser)
			end

			vim.api.nvim_create_autocmd({ "FileType" }, {
				pattern = fts,
				callback = function(event)
					local parser = parser_by_ft[event.match] or event.match
					vim.treesitter.start(event.buf, parser)
					-- folding / indentation scoped to the buffer being opened,
					-- instead of only the window that was current at startup
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
