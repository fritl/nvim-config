return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer", -- source for text in buffer
        "hrsh7th/cmp-path", -- source for file system paths
        {
            "L3MON4D3/LuaSnip",
            -- follow latest release.
            version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- install jsregexp (optional!).
            build = "make install_jsregexp",
        },
        "saadparwaiz1/cmp_luasnip", -- for autocompletion
        "rafamadriz/friendly-snippets", -- useful snippets
        "onsails/lspkind.nvim", -- vs-code like pictograms
    },
    config = function()
        local cmp = require("cmp")

        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        -- Keymaps for jumping between insert points
        vim.keymap.set({ "i", "s" }, "<leader>n", function()
            if luasnip.expand_or_jump then
                luasnip.expand_or_jump()
            end
        end, { silent = false, desc = "Go to next insert point" })
        vim.keymap.set({ "i", "s" }, "<leader>p", function()
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end, { silent = true, desc = "Go to previous insert point" })

        -- Custom snippets
        luasnip.add_snippets("c", {
            luasnip.snippet("newFile", {
                luasnip.text_node({ "/**", " * @file " }),
                luasnip.function_node(function()
                    return vim.fn.expand("%:t")
                end),
                luasnip.text_node({ "", " * @brief " }),
                luasnip.insert_node(1, "<short brief>"),
                luasnip.text_node({ "", " * @author Lukas Fritz (lukas.fritz09@htl-sazburg.ac.at)" }),
                luasnip.text_node({ "", " * @date " }),
                luasnip.function_node(function()
                    return os.date("%Y-%m-%d")
                end),
                luasnip.text_node({ "", "cls; gcc " }),
                luasnip.function_node(function()
                    return vim.fn.expand("%:t")
                end),
                luasnip.text_node(" -Wall -Werror -o run.exe; PAUSE; cls; .\\run.exe"),
                luasnip.text_node({ "", "*/" }),
            }),
        })
        -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            completion = {
                completeopt = "menu,menuone,preview,noselect",
            },
            snippet = { -- configure how nvim-cmp interacts with snippet engine
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = {
                ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                ["<Down>"] = cmp.mapping.select_next_item(), -- next suggestion
                ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                ["<Up>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                ["<C-e>"] = cmp.mapping.abort(), -- close completion window
                ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                ["<Tab>"] = cmp.mapping(function(fallback)
                    -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
                    if cmp.visible() then
                        local entry = cmp.get_selected_entry()
                        if not entry then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        end
                        cmp.confirm()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },
            -- sources for autocompletion
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- snippets
                { name = "path" }, -- file system paths
            }),

            -- configure lspkind for vs-code like pictograms in completion menu
            formatting = {
                format = lspkind.cmp_format({
                    maxwidth = 50,
                    ellipsis_char = "...",
                }),
            },
        })
    end,
}
