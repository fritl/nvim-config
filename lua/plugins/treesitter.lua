return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({
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
