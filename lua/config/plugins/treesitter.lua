return {
    {
        "nvim-treesitter/nvim-treesitter",
        cond = not vim.g.vscode,
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                    "c",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "javascript",
                    "css",
                    "scss",
                    "html",
                    "python",
                },
                ignore_install = {},
                auto_install = false,
                sync_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
}
