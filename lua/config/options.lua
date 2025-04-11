if not vim.g.vscode then
    vim.cmd("colorscheme catppuccin-frappe")
end
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

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
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.wrap = true

vim.diagnostic.config({ virtual_text = true })
vim.diagnostic.config({ virtual_lines = { current_line = true } })
