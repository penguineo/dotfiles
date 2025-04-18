return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	config = function()
		require('lualine').get_config()
		require('lualine').setup({
		})
		end,
	}
