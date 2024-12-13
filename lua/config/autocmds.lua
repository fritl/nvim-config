vim.api.nvim_create_augroup("Compile", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "Compile",
  pattern = "*.c",
  desc = "Automatically compile c file",
  callback = function()
    local file = vim.fn.expand("%")
    vim.fn.jobstart({ "gcc", file, "-orun.out" })
  end,
})
