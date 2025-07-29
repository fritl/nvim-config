vim.keymap.set("n", "<leader>wsv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
vim.keymap.set("n", "<leader>wsh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], {desc = "Yank selection into the system clipboard" })
vim.keymap.set({"n", "v"}, "<leader>Y", [["+Y]], {desc = "Yank line into the system clipboard"})

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down (Visual)" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up (Visual)" })
