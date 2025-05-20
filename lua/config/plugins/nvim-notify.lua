return {
    {
        "rcarriga/nvim-notify",
        config = function()
            vim.notify = require("notify")
            require("notify").setup({
                render = "compact",
                stages = "slide",
            })
        end,
    },
}
