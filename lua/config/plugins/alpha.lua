return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- Set header
        dashboard.section.header.val = {
            "██╗    ██╗   ██╗███████╗███████╗    ██╗   ██╗██╗███╗   ███╗   ",
            "██║    ██║   ██║██╔════╝██╔════╝    ██║   ██║██║████╗ ████║   ",
            "██║    ██║   ██║███████╗█████╗      ██║   ██║██║██╔████╔██║   ",
            "██║    ██║   ██║╚════██║██╔══╝      ╚██╗ ██╔╝██║██║╚██╔╝██║   ",
            "██║    ╚██████╔╝███████║███████╗     ╚████╔╝ ██║██║ ╚═╝ ██║▄█╗",
            "╚═╝     ╚═════╝ ╚══════╝╚══════╝      ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝",
            "                                                              ",
            "                ██████╗ ████████╗██╗    ██╗                   ",
            "                ██╔══██╗╚══██╔══╝██║    ██║                   ",
            "                ██████╔╝   ██║   ██║ █╗ ██║                   ",
            "                ██╔══██╗   ██║   ██║███╗██║                   ",
            "                ██████╔╝   ██║   ╚███╔███╔╝                   ",
            "                ╚═════╝    ╚═╝    ╚══╝╚══╝                    ",
        }
        -- Set menu
        dashboard.section.buttons.val = {
            dashboard.button("n", "  > New File", "<cmd>ene<CR>"),
            dashboard.button("f", "  > Find file", "<cmd>Telescope find_files<CR>"),
            dashboard.button("l", "  > Last files", "<cmd>Telescope oldfiles<cr>"),
            dashboard.button("e", "  > Toggle File Tree", "<cmd>NvimTreeToggle<cr>"),
            dashboard.button("s", "  > Find string", "<cmd>Telescope live_grep<CR>"),
            dashboard.button("r", "󰁯  > Restore Session", "<cmd>SessionRestore<CR>"),
            dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
        }

        -- Send config to alpha
        alpha.setup(dashboard.opts)

        -- Disable folding on alpha buffer
        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
}
