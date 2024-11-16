return {
	"mfussenegger/nvim-dap",
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
		vim.keymap.set("n", "<leader>di", function()
			dap.step_into()
		end, { desc = "step into" })
		vim.keymap.set("n", "<leader>do", function()
			dap.step_out()
		end, { desc = "step out" })
		vim.keymap.set("n", "<leader>db", function()
			dap.toggle_breakpoint()
		end, { desc = "toggle breakpoint" })
		vim.keymap.set("n", "<leader>dc", function()
			dap.continue()
		end, { desc = "Continue" })
		dap.adapters.lldb = {
			type = "executable",
			name = "lldb",
		}
		dap.configurations.c = dap.configurations.cpp
		require("mason").setup()
		require("mason-nvim-dap").setup()
	end,
}
