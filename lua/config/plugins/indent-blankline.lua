return {
    {
        "lukas-reineke/indent-blankline.nvim",
        enabled = false,
        cond = not vim.g.vscode,
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
    },
}
