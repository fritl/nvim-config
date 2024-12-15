vim.api.nvim_create_augroup("Compile", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "Compile",
  pattern = "*.c",
  desc = "Automatically compile c file",
  callback = function()
    local file = vim.fn.expand("%")
    local output_file = vim.loop.os_uname().sysname:match("Windows") and "run.exe" or "run.out"
    vim.fn.jobstart({ "rm", output_file })
    vim.fn.jobstart({ "gcc", file, "-o", output_file }, {
      on_stderr = function(_, data, _)
        if data then
          vim.notify(table.concat(data, "\n"), vim.log.levels.OFF)
        end
      end,
    })
  end,
})
