-- Custom user commands for quick theme/apparence toggles.

local DARK = "catppuccin-mocha"
local LIGHT = "catppuccin-latte"

--- Toggle between the dark (mocha) and light (latte) flavourscheme
local function toggle_light_mode()
	if vim.g.colors_name == LIGHT then
		vim.cmd.colorscheme(DARK)
	else
		vim.cmd.colorscheme(LIGHT)
	end
end

--- Toggle catppuccin's transparent background on/off and re-apply the current flavourscheme
local function toggle_transparency()
	local catppuccin = require("catppuccin")
	catppuccin.options.transparent_background = not catppuccin.options.transparent_background
	catppuccin.compile()
	vim.cmd("colorscheme " .. (vim.g.colors_name or DARK))
end

vim.api.nvim_create_user_command("LightMode", toggle_light_mode, {
	desc = "Toggle between catppuccin dark (mocha) and light (latte)",
})

vim.api.nvim_create_user_command("ToggleTransparency", toggle_transparency, {
	desc = "Toggle catppuccin transparent background",
})
