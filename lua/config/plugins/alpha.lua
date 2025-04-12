return {
    "goolord/alpha-nvim",
    cond = not vim.g.vscode,
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        local headers = {
            {
                "                                    ██████                                    ",
                "                                ████▒▒▒▒▒▒████                                ",
                "                              ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                              ",
                "                            ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                            ",
                "                          ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒                              ",
                "                          ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▓▓▓▓                          ",
                "                          ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▒▒▓▓                          ",
                "                        ██▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒    ██                        ",
                "                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ",
                "                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ",
                "                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ",
                "                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ",
                "                        ██▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒██                        ",
                "                        ████  ██▒▒██  ██▒▒▒▒██  ██▒▒██                        ",
                "                        ██      ██      ████      ████                        ",
            },
            {
                [[                                                   ]],
                [[                                              ___  ]],
                [[                                           ,o88888 ]],
                [[                                        ,o8888888' ]],
                [[                  ,:o:o:oooo.        ,8O88Pd8888"  ]],
                [[              ,.::.::o:ooooOoOoO. ,oO8O8Pd888'"    ]],
                [[            ,.:.::o:ooOoOoOO8O8OOo.8OOPd8O8O"      ]],
                [[           , ..:.::o:ooOoOOOO8OOOOo.FdO8O8"        ]],
                [[          , ..:.::o:ooOoOO8O888O8O,COCOO"          ]],
                [[         , . ..:.::o:ooOoOOOO8OOOOCOCO"            ]],
                [[          . ..:.::o:ooOoOoOO8O8OCCCC"o             ]],
                [[             . ..:.::o:ooooOoCoCCC"o:o             ]],
                [[             . ..:.::o:o:,cooooCo"oo:o:            ]],
                [[          `   . . ..:.:cocoooo"'o:o:::'            ]],
                [[          .`   . ..::ccccoc"'o:o:o:::'             ]],
                [[         :.:.    ,c:cccc"':.:.:.:.:.'              ]],
                [[       ..:.:"'`::::c:"'..:.:.:.:.:.'               ]],
                [[     ...:.'.:.::::"'    . . . . .'                 ]],
                [[    .. . ....:."' `   .  . . ''                    ]],
                [[  . . . ...."'                                     ]],
                [[  .. . ."'                                         ]],
                [[ .                                                 ]],
                [[                                                   ]],
            },
            {
                [[        ___,-----.___]],
                [[    ,--'             `--.]],
                [[   /                     \]],
                [[  /                       \]],
                [[ |                         |]],
                [[|                           |]],
                [[|        |~~~~~~~~~|        |]],
                [[|        \         /        |]],
                [[ |        \       /        |]],
                [[  \        \     /        /]],
                [[   \        |   |        /]],
                [[    \       |   |       /]],
                [[     \      |   |      /]],
                [[      \     |   |     /]],
                [[       \____|___| ___/]],
                [[       )___,-----'___(]],
                [[       )___,-----'___(]],
                [[       )___,-----'___(]],
                [[       )___,-----'___(]],
                [[       \_____________/]],
                [[            \___/]],
            },
        }

        -- Zufälligen Header auswählen
        math.randomseed(os.time())
        local random_header = headers[math.random(#headers)]
        -- Set header
        dashboard.section.header.val = random_header
        -- Set menu
        dashboard.section.buttons.val = {
            dashboard.button("n", "  > New File", "<cmd>ene<CR>"),
            dashboard.button("f", "  > Find file", "<cmd>Telescope find_files<CR>"),
            dashboard.button("l", "  > Last files", "<cmd>Telescope oldfiles<cr>"),
            dashboard.button("e", "  > Toggle File Tree", "<cmd>Oil<cr>"),
            dashboard.button("s", "  > Find string", "<cmd>Telescope live_grep<CR>"),
            dashboard.button("r", "󰁯  > Restore Session", "<cmd>SessionRestore<CR>"),
            dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
        }

        -- Send config to alpha
        alpha.setup(dashboard.opts)

        -- Disable folding on alpha buffer
        vim.cmd("autocmd FileType alpha setlocal nofoldenable")
    end,
}
