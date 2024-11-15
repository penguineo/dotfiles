return {
	"nvimtools/none-ls.nvim",
	event = "BufEnter",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- Formatting
				null_ls.builtins.formatting.stylua.with({ filetypes = { "lua" } }),
				null_ls.builtins.formatting.gofumpt.with({ filetypes = { "go" } }),
				null_ls.builtins.formatting.golines.with({ filetypes = { "go" } }),
				null_ls.builtins.formatting.goimports_reviser.with({ filetypes = { "go" } }),
				null_ls.builtins.formatting.markdownlint.with({ filetypes = { "markdown" } }),
				null_ls.builtins.formatting.prettier.with({
					filetypes = { "javascript", "typescript", "html", "css", "json" },
				}),
				null_ls.builtins.formatting.black.with({ filetypes = { "python" } }),
				null_ls.builtins.formatting.stylelint,
				null_ls.builtins.formatting.shfmt,

				-- Completions
				null_ls.builtins.completion.spell.with({ filetypes = { "markdown", "text" } }),
				null_ls.builtins.completion.vsnip,
				null_ls.builtins.completion.tags,
				null_ls.builtins.completion.luasnip,

				-- Diagnostics
				null_ls.builtins.diagnostics.golangci_lint.with({ filetypes = { "go" } }),
				null_ls.builtins.diagnostics.markdownlint_cli2.with({ filetypes = { "markdown" } }),
				null_ls.builtins.diagnostics.mypy.with({ filetypes = { "python" } }),
				null_ls.builtins.diagnostics.pylint.with({ filetypes = { "python" } }),
				null_ls.builtins.diagnostics.yamllint.with({ filetypes = { "yaml" } }),
				null_ls.builtins.diagnostics.tidy,
				null_ls.builtins.diagnostics.dotenv_linter,
				null_ls.builtins.diagnostics.gitlint,

				-- Hover
				null_ls.builtins.hover.dictionary,
				null_ls.builtins.hover.printenv,

				-- Code Actions
				null_ls.builtins.code_actions.refactoring,
				null_ls.builtins.code_actions.gitsigns,
				null_ls.builtins.code_actions.gitrebase,
				null_ls.builtins.code_actions.textlint,
				null_ls.builtins.code_actions.proselint,
				null_ls.builtins.code_actions.impl,
				null_ls.builtins.code_actions.gomodifytags,
				-- None-ls extras
				require("none-ls.code_actions.eslint_d"),
				require("none-ls.diagnostics.eslint_d"),
				require("none-ls.formatting.eslint_d"),
				require("none-ls.diagnostics.ruff"),
				require("none-ls.diagnostics.yamllint"),
				require("none-ls.formatting.trim_whitespace"),
				require("none-ls.formatting.ruff_format"),
				require("none-ls.formatting.trim_newlines"),
			},
		})
	end,
}
