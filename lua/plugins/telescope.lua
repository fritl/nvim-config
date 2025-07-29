return {
    'nvim-telescope/telescope.nvim',
    -- Should switch branch back to 0.1.x later but 0.1.x is bugy right now
    -- branch = '0.1.x',
    branch = "master",
    dependencies = { 'nvim-lua/plenary.nvim',
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        telescope.setup({
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown({}),
                },
            },
            defaults = {
                path_display = { "smart" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next, -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist,
                    },
                },
            },
        })

        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")

        -- set keymaps
        local keymap = vim.keymap -- for conciseness
        keymap.set("n", "<leader>fs", "<cmd>Telescope find_files<cr>", { desc = ".. Search" })
        keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = ".. Search recent" })
        keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = ".. Grep String" })
        keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = ".. Search buffers" })
    end,

}
