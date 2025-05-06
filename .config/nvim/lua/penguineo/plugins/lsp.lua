return {
	-- Auto-completion setup
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer", -- Buffer completions
			"hrsh7th/cmp-path", -- Path completions
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp", -- Make sure you have JS regexp support
			},
			"saadparwaiz1/cmp_luasnip", -- LuaSnip completions
			"rafamadriz/friendly-snippets", -- A collection of useful snippets
			"onsails/lspkind.nvim",  -- Adds icons to completion items
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			-- Lazy load VSCode-style snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,preview,noselect", -- Completion settings
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body) -- Snippet expansion for LuaSnip
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-j>"] = cmp.mapping.scroll_docs(-4),
					["<C-k>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- LSP completions
					{ name = "luasnip" }, -- Snippet completions
					{ name = "buffer" }, -- Buffer completions
					{ name = "path" }, -- Path completions
				}),
				formatting = {
					expandable_indicator = true,
					format = lspkind.cmp_format({
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
			})
		end,
	},

	-- Mason setup for managing LSP servers and tools
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim", -- Mason integration with lspconfig
			"WhoIsSethDaniel/mason-tool-installer.nvim", -- Manage external tools
		},
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")

			-- Mason setup for package installation
			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			-- Automatically install LSP servers
			mason_lspconfig.setup({
				ensure_installed = {
					"html", "cssls", "tailwindcss", "lua_ls", "ruff", -- Add LSP servers to install
				},
			})

			-- Automatically install external tools like linters and formatters
			mason_tool_installer.setup({
				ensure_installed = {
					"prettier", "stylua", "isort", "black", "pylint", "eslint_d", -- Add tools to install
				},
			})
		end,
	},

	-- LSP configuration with keybindings and server setups
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",                          -- LSP support for nvim-cmp
			{ "antosha417/nvim-lsp-file-operations", config = true }, -- LSP file operations like rename
			{ "folke/neodev.nvim",                   opts = {} }, -- Lua development setup
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local keymap = vim.keymap

			-- Create autocommand group for LSP Attach
			-- Correcting the LspAttach callback function with valid key mappings

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }

					-- Ensure all mappings use valid LSP functions or valid commands
					-- Go to declaration
					opts.desc = "Go to declaration"
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

					-- Show LSP definitions
					opts.desc = "Show LSP definitions"
					vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

					-- Show LSP implementations
					opts.desc = "Show LSP implementations"
					vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

					-- Show LSP type definitions
					opts.desc = "Show LSP type definitions"
					vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

					-- Code action
					opts.desc = "See available code actions"
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

					-- Smart rename
					opts.desc = "Smart rename"
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

					-- Show buffer diagnostics
					opts.desc = "Show buffer diagnostics"
					vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

					-- Show line diagnostics
					opts.desc = "Show line diagnostics"
					vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

					-- Go to previous diagnostic
					opts.desc = "Go to previous diagnostic"
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

					-- Go to next diagnostic
					opts.desc = "Go to next diagnostic"
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

					-- Show documentation for what is under cursor
					opts.desc = "Show documentation for what is under cursor"
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

					-- Restart LSP
					opts.desc = "Restart LSP"
					vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
				end,
			})

			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- Define diagnostic signs with icons
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			-- Mason LSP setup handlers
			mason_lspconfig.setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["lua_ls"] = function()
					lspconfig["lua_ls"].setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
								completion = {
									callSnippet = "Replace", -- Lua snippet behavior
								},
							},
						},
					})
				end,
			})
		end,
	},

	-- Linting setup
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("lint").linters_by_ft = {
				go = { "gospel" },
				lua = { "luacheck" },
				python = { "mypy" },
				css = { "stylelint" },
				markdown = { "markdownlint-cli2" },
				yaml = { "yamllint" },
				html = { "htmlhint" }
			}

			-- Lint on write, enter, and after insert leave
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
