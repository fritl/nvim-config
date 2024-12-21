vim.g.mapleader = " "

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

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down (Visual)" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up (Visual)" })
vim.keymap.set("t", "<esc>", '<C-\\><C-n>"', { desc = "Exit Terminal" })
vim.keymap.set("n", "<leader>wt", function()
  if vim.fn.has("win32") == 1 then
    vim.cmd.terminal("powershell")
  else
    vim.cmd.terminal()
  end
  local win_id = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(win_id, math.max(80, vim.api.nvim_win_get_height(win_id)))
end, { desc = "Open terminal in split" })

local function open_floating_window(buffer)
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  local win_width = math.floor(width * 0.8)
  local win_height = math.floor(height * 0.8)

  local row = math.floor((height - win_height) / 2)
  local col = math.floor((width - win_width) / 2)

  local opts = {
    style = "minimal",
    relative = "editor",
    border = "rounded",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
  }

  return vim.api.nvim_open_win(buffer, true, opts)
end

local floating_terminal = {
  buf = nil,
  win = nil,
}

local function toggle_floating_terminal()
  if floating_terminal.win and vim.api.nvim_win_is_valid(floating_terminal.win) then
    vim.api.nvim_win_hide(floating_terminal.win)
    floating_terminal.win = nil
  elseif floating_terminal.buf and vim.api.nvim_buf_is_valid(floating_terminal.buf) then
    floating_terminal.win = open_floating_window(floating_terminal.buf)
  else
    floating_terminal.buf = vim.api.nvim_create_buf(false, true)
    floating_terminal.win = open_floating_window(floating_terminal.buf)

    if vim.fn.has("win32") == 1 then
      vim.cmd.terminal("powershell")
    else
      vim.cmd.terminal()
    end
    vim.api.nvim_buf_set_option(floating_terminal.buf, "buflisted", false)
  end
end

vim.api.nvim_create_user_command("ToggleFloating", toggle_floating_terminal, {})
vim.keymap.set({ "n", "t" }, "<leader>ct", toggle_floating_terminal, { desc = "Create Terminal" })
