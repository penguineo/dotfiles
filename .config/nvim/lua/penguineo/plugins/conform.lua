return{
  'stevearc/conform.nvim',
	config = function()
		require("conform").setup({
			formatted_by_ft = {
				lua = {"stylua"},
				python = {"isort", "blackd"},
				rust = {"rustfmt", lsp_format = "fallback"},
				javascript = {"prettierd","eslintd"},
				typescript = {"prettierd","eslintd"},
			}
		})
	end,
}
