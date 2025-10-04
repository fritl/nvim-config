-- vim.cmd.colorscheme("slate")
vim.cmd.colorscheme("catppuccin-mocha")

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.smartindent = true

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.signcolumn = "yes"

vim.opt.foldmethod = "expr"

vim.opt.swapfile = false
vim.opt.backup = false
if vim.fn.has("win32") == 1 then
	vim.opt.undodir = os.getenv("USERPROFILE") .. "\\.vim\\undodir"
else
	vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end

vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.wrap = true
vim.opt.smoothscroll = true

vim.diagnostic.config({ virtual_text = true })
