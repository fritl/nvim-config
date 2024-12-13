vim.g.mapleader = " "

-- For autosession
vim.keymap.set("n", "<leader>ww", "<cmd>SessionSave<CR>", { desc = "Write the session" })
vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore the saved session" })
-- window management
vim.keymap.set("n", "<leader>wsv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
vim.keymap.set("n", "<leader>wsh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height

vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
vim.keymap.set("n", "<A-l>", "<cmd>tabnext<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "<A-h>", "<cmd>tabprevious<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<A-k>", "<cmd>bprevious<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<A-j>", "<cmd>bnext<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down (Visual)" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up (Visual)" })
