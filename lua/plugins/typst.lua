return {
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        -- Downloads the (tinymist) preview binary on install/build
        build = function()
            require("typst-preview").update()
        end,
        opts = {},
        keys = {
            { "<leader>tp", "<cmd>TypstPreviewToggle<cr>", ft = "typst", desc = "Toggle Typst preview" },
            { "<leader>tP", "<cmd>TypstPreviewUpdate<cr>", ft = "typst", desc = "Force update Typst preview" },
        },
    },
}
