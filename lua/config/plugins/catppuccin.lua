return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        cond = not vim.g.vscode,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                integrations = {
                    blink_cmp = false,
                },
            })
        end,
    },
}
