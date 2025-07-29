return {
    "danymat/neogen",
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*" 
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function ()
        local neogen = require("neogen")
        neogen.setup({ enabled = true })

        vim.keymap.set("n", "<leader>gf", function ()
            neogen.generate({type = "func"})
        end, {desc = "Generate docstring for current fucntion"})

        vim.keymap.set("n", "<leader>gc", function ()
            neogen.generate({type = "class"})
        end, {desc = "Generate docstring for current class"})

        vim.keymap.set("n", "<leader>gt", function ()
            neogen.generate({type = "type"})
        end, {desc = "Generate docstring for current type"})
    end
}
