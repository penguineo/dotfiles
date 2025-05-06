return{
	'stevearc/oil.nvim',
	dependencies = {"echasnovski/mini.icons"},
	lazy = false,
	config = function()
		require("oil").setup()
		vim.keymap.set("n", "\\", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
