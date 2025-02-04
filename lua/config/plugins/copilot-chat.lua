return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        cond = not vim.g.vscode,
        branch = "main",
        dependencies = {
            { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
            { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        config = function()
            vim.g.copilot_enabled = false
        end,
        opts = {
            -- See Configuration section for options
        },
        -- See Commands section for default commands if you want to lazy load on them
    },
}
