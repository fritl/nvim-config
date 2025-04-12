return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        cond = not vim.g.vscode,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                custom_highlights = function(colors)
                    return {
                        BlinkCmpGhostText = { fg = "#aaaaaa", bg = colors.none },
                    }
                end,
                integrations = {
                    blink_cmp = true,
                    mason = true,
                    cmp = false,
                    copilot_vim = true,
                    which_key = true,
                    lsp_trouble = true,
                },
            })
        end,
    },
}
