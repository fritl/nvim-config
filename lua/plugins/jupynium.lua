return {
    "rcarriga/nvim-notify",   -- optional
    "stevearc/dressing.nvim", -- optional, UI for :JupyniumKernelSelect
    {
        "kiyoon/jupynium.nvim",

        build = (vim.loop.os_uname().sysname == "Windows_NT") and
            "python3 -m pip install --user ." or
            "python3 -m venv venv && source venv/bin/activate && pip3 install .",
        -- build = "uv pip install . --python=$HOME/.virtualenvs/jupynium/bin/python",
        -- build = "conda run --no-capture-output -n jupynium pip install .",
        config = function()
            local plugin_path = vim.fn.stdpath("data") .. "/lazy/jupynium.nvim/"
            require("jupynium").setup({
                python_host = (vim.loop.os_uname().sysname == "Windows_NT") and "python3" or
                    plugin_path .. "venv/bin/python",
                default_notebook_URL = "localhost:8888/",
            })
        end
    },
}
