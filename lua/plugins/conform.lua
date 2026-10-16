return {
    "stevearc/conform.nvim",
    -- Formatter binaries read their own local config files, so this respects
    -- .prettierrc, rustfmt.toml, .clang-format, pyproject.toml, etc. per project.
    opts = {
        -- LSP formatting is used as fallback for filetypes without a formatter here
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff" },
            rust = { "rustfmt" },
            c = { "clang-format" },
            javascript = { "prettierd" },
            javascriptreact = { "prettierd" },
            typescript = { "prettierd" },
            typescriptreact = { "prettierd" },
            json = { "prettierd" },
            html = { "prettierd" },
            css = { "prettierd" },
            scss = { "prettierd" },
            markdown = { "prettierd" },
            typst = { "typstyle" },
        },
    },
}
