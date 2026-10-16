-- Database access: vim-dadbod (+ UI + completion)
--
-- Connections live in a gitignored lua/dbs.lua (see dbs.lua.example).
-- SQL buffers remember their connection via b:db (set with <leader>dc).

return {
    { "tpope/vim-dadbod", ft = { "sql", "mysql", "plsql" } },

    {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
        dependencies = { "tpope/vim-dadbod" },
    },

    {
        "kristijanhusak/vim-dadbod-ui",
        ft = { "sql", "mysql", "plsql" },
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameConnection", "DBUILastQueryInfo" },
        keys = {
            { "<leader>du", "<cmd>DBUIToggle<cr>", desc = "Toggle Database UI" },
        },
        dependencies = { "tpope/vim-dadbod" },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_queries"
            -- Never auto-execute on save: lesson files hold many queries and
            -- execution stays explicit (<leader>dx / <leader>dX)
            vim.g.db_ui_execute_on_save = 0

            -- Load local, gitignored connection definitions
            local ok, dbs = pcall(require, "dbs")
            if ok and type(dbs) == "table" then
                vim.g.dbs = dbs
            end

            -- Buffer-local setup for every SQL file
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sql", "mysql", "plsql" },
                callback = function(args)
                    local opts = { buffer = args.buf, silent = true }

                    local function connected()
                        return vim.b.db ~= nil and vim.b.db ~= ""
                    end

                    -- Pick a connection for this buffer
                    vim.keymap.set("n", "<leader>dc", function()
                        local dbs = vim.g.dbs or {}
                        if vim.tbl_isempty(dbs) then
                            vim.notify(
                                "No connections configured — copy dbs.lua.example to lua/dbs.lua and add your URLs",
                                vim.log.levels.WARN
                            )
                            return
                        end
                        local candidates = { { name = "(disconnect this buffer)" } }
                        vim.list_extend(candidates, dbs)
                        vim.ui.select(candidates, {
                            prompt = "Database for this buffer",
                            format_item = function(item)
                                return item.name
                            end,
                        }, function(choice)
                            if choice then
                                if choice.url then
                                    vim.b.db = choice.url
                                    vim.notify("Buffer connected to: " .. choice.name)
                                else
                                    vim.b.db = nil
                                end
                            end
                        end)
                    end, opts)

                    -- True if line `i` (1-based) is blank
                    local function blank(i)
                        local line = vim.fn.getline(i)
                        return line == nil or line:find("%S") == nil
                    end

                    -- Find the query block (contiguous non-blank lines) for the
                    -- cursor line. On a blank line, fall back to the nearest
                    -- non-blank line (above first, then below).
                    local function query_block()
                        local count = vim.api.nvim_buf_line_count(0)
                        local cur = vim.api.nvim_win_get_cursor(0)[1]
                        if blank(cur) then
                            local up, down = cur - 1, cur + 1
                            while up >= 1 and blank(up) do
                                up = up - 1
                            end
                            while down <= count and blank(down) do
                                down = down + 1
                            end
                            if up >= 1 then
                                cur = up
                            elseif down <= count then
                                cur = down
                            else
                                return nil
                            end
                        end
                        local top, bottom = cur, cur
                        while top > 1 and not blank(top - 1) do
                            top = top - 1
                        end
                        while bottom < count and not blank(bottom + 1) do
                            bottom = bottom + 1
                        end
                        return top, bottom
                    end

                    -- Execute query around cursor (blank-line separated)
                    vim.keymap.set("n", "<leader>dx", function()
                        if not connected() then
                            vim.notify("No connection — pick one with <leader>dc", vim.log.levels.WARN)
                            return
                        end
                        local top, bottom = query_block()
                        if not top then
                            vim.notify("No query lines in this buffer", vim.log.levels.WARN)
                            return
                        end
                        vim.cmd(top .. "," .. bottom .. "DB")
                    end, opts)

                    -- Execute whole file
                    vim.keymap.set("n", "<leader>dX", function()
                        if not connected() then
                            vim.notify("No connection — pick one with <leader>dc", vim.log.levels.WARN)
                            return
                        end
                        vim.cmd("%DB")
                    end, opts)

                    -- Execute visual selection
                    vim.keymap.set("x", "<leader>dx", function()
                        if not connected() then
                            vim.notify("No connection — pick one with <leader>dc", vim.log.levels.WARN)
                            return
                        end
                        vim.cmd("'<,'>DB")
                    end, opts)

                    -- ER diagram of the connected schema
                    vim.keymap.set("n", "<leader>dE", "<cmd>DBERD<cr>", opts)
                end,
            })
        end,
    },
}
