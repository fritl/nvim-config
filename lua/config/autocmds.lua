vim.api.nvim_create_augroup("Compile", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "Compile",
  pattern = "*.c",
  desc = "Automatically compile c file",
  callback = function()
    local file = vim.fn.expand("%")
    vim.fn.jobstart({ "rm", "run.out" })
    vim.fn.jobstart({ "gcc", file, "-orun.out" }, {
      on_stderr = function(_, data, _)
        if data then
          vim.notify(table.concat(data, "\n"), vim.log.levels.OFF)
        end
      end,
    })
  end,
})
