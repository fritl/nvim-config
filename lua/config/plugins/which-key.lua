return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        cond = not vim.g.vscode,
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {
            spec = {
                { "<leader>f", "File .." },
                { "<leader>t", "Tab .. / Trouble .." },
                { "<leader>w", "Window" },
                { "<leader>ws", "Split" },
                { "<leader>c", "Code" },
                { "<leader>d", "debug" },
            },
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
}
