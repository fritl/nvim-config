return {
    {
        "rmagatti/auto-session",
        cond = not vim.g.vscode,
        opts = {
            suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
            auto_restore = false,
            -- log_level = 'debug',
        },
    },
}
