return {
    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = {"rafamadriz/friendly-snippets", { "echasnovski/mini.icons", opts = {} }},

        version = "*",

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "default",
                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<Tab>"] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.accept()
                        else
                            return cmp.select_and_accept()
                        end
                    end,
                    "snippet_forward",
                    "fallback",
                },
                ["<C-space>"] = { "show", "fallback" },
            },
            appearance = {
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            signature = {
                enabled = true,
                window = {
                    show_documentation = false,
                    border = "rounded",
                },
            },
            completion = {

                list = {
                    selection = {
                        preselect = true,
                        auto_insert = false,
                    },
                },
                -- Show documentation when selecting a completion item
                ghost_text = {
                    enabled = true,
                },
                documentation = { auto_show = true, auto_show_delay_ms = 0, window = { border = "rounded" } },
                menu = {
                    border = "rounded",
                    draw = {
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                                    return kind_icon
                                end,
                                -- (optional) use highlights from mini.icons
                                highlight = function(ctx)
                                    local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                                    return hl
                                end,
                            },
                            kind = {
                                -- (optional) use highlights from mini.icons
                                highlight = function(ctx)
                                    local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                                    return hl
                                end,
                            },
                        },
                    },
                },
            },
            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            -- sources = {
            --   default = { "lsp", "path", "snippets", "buffer" },
            -- },
        },
        opts_extend = { "sources.default" },
    },
}

