local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local isolated_completion_kind = nil
function isolate_completion(example, tbl)
	local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
	if isolated_completion_kind ~= nil and isolated_completion_kind[example] ~= nil then
		isolated_completion_kind = nil -- Reset completion filter
	else
		isolated_completion_kind = tbl
	end
	require("blink.cmp").cancel()
	vim.schedule(require("blink.cmp").show)
end

require("lazy").setup({
	{ "nvim-treesitter/nvim-treesitter", lazy = false, branch = "main", build = ":TSUpdate" },
	{ "tanvirtin/monokai.nvim" },
	{ "xzbdmw/colorful-menu.nvim" },
	{
		"saghen/blink.cmp",
		version = "1.*",
		opts = {
			keymap = {
				preset = "super-tab",
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-k>"] = { "show_signature", "hide_signature", "fallback" },

				-- Show only variable-like symbols
				["<C-v>"] = {
					function()
						local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
						isolate_completion(CompletionItemKind.Property, {
							[CompletionItemKind.Field] = true,
							[CompletionItemKind.Variable] = true,
							[CompletionItemKind.Property] = true,
							[CompletionItemKind.EnumMember] = true,
							[CompletionItemKind.Constant] = true,
							[CompletionItemKind.Event] = true,
						})
					end,
				},
				-- Show only function-like symbols
				["<C-f>"] = {
					function()
						local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
						isolate_completion(CompletionItemKind.Method, {
							[CompletionItemKind.Method] = true,
							[CompletionItemKind.Function] = true,
							[CompletionItemKind.Constructor] = true,
							[CompletionItemKind.Operator] = true,
						})
					end,
				},
				-- Show only type-like symbols
				["<C-t>"] = {
					function()
						local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
						isolate_completion(CompletionItemKind.Class, {
							[CompletionItemKind.Class] = true,
							[CompletionItemKind.Interface] = true,
							[CompletionItemKind.Module] = true,
							[CompletionItemKind.Enum] = true,
							[CompletionItemKind.Struct] = true,
							[CompletionItemKind.TypeParameter] = true,
							[CompletionItemKind.Keyword] = true,
						})
					end,
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
			completion = {
				keyword = { range = "full" },
				menu = {
					draw = {
						columns = { { "kind_icon", gap = 1, "kind" }, { "label", gap = 1 } },
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
						},
					},
				},
				trigger = { show_on_trigger_character = true },
				documentation = {
					auto_show = true,
				},
			},
			signature = { enabled = true },
			sources = {
				transform_items = function(_, items)
					items = vim.tbl_filter(function(item)
						return isolated_completion_kind == nil or isolated_completion_kind[item.kind] ~= nil
					end, items)
					return items
				end,
			},
		},
	},
	{ "mason-org/mason.nvim", opts = {} },
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"pylsp",
				"ts_ls",
				"html",
				-- "csharp_ls",
				"omnisharp",
				"fsautocomplete",
				"tinymist",
				"clangd",
				"arduino_language_server",
				"ltex",
				"texlab",
			},
		},
	},
	{ "nvim-telescope/telescope.nvim" },
	{
		"chomosuke/typst-preview.nvim",
		lazy = false,
		version = "1.*",
		opts = {
			dependencies_bin = {
				["tinymist"] = "tinymist", -- Use tinymist installed via Mason, assuming it is in path (avoids version mismatch between LSP and preview)
			},
			-- specify local relative paths for fonts (must be consistent with LSP setting & CLI args!)
			extra_args = { "--font-path", "./common/fonts", "--font-path", "./fonts" },
		},
	},
	{
		"mfussenegger/nvim-dap",
	},
	{ "nvim-neotest/nvim-nio" },
	{
		"rcarriga/nvim-dap-ui",
		opts = {
			ensure_installed = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		},
	},
	{ "mfussenegger/nvim-dap-python" },
	{
		"lewis6991/gitsigns.nvim",
		keys = {
			{
				"<leader>gb",
				"<cmd>Gitsigns toggle_current_line_blame<cr>",
				desc = "Toggle git inline blame",
			},
			{
				"<leader>gc",
				"<cmd>Gitsigns setloclist<cr>",
				desc = "Show list of git change locations",
			},
			{
				"<leader>gd",
				"<cmd>Gitsigns diffthis<cr>",
				desc = "Show git diff",
			},
		},
		lazy = false,
	},
	{ "tpope/vim-commentary" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.cmd([[Lazy load markdown-preview.nvim]])
			vim.fn["mkdp#util#install"]()
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			scroll = {},
			dashboard = {
				sections = {
					{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
					{ section = "keys", gap = 1 },
					{ section = "startup" },
				},
			},
			picker = {},
			explorer = {},
			indent = {},
			input = {},
			lazygit = {},
			notifier = {},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {},
	},
	{ "jlcrochet/vim-razor" },
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>x",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xs",
				"<cmd>Trouble symbols toggle focus=true<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>xd",
				"<cmd>Trouble lsp toggle focus=true win.position=bottom<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
		},
		modes = {
			mydiags = {
				mode = "diagnostics", -- inherit from diagnostics mode
				filter = {
					any = {
						buf = 0, -- current buffer
						{
							severity = vim.diagnostic.severity.ERROR, -- errors only
							-- limit to files in the current project
							function(item)
								return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
							end,
						},
					},
				},
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		lazy = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			highlight = {
				pattern = [[.*<(KEYWORDS)\s*]],
			},
			search = {
				pattern = [[\b(KEYWORDS)\b]],
			},
		},
		keys = {
			{
				"<leader>xt",
				"<cmd>TodoTrouble<cr>",
				desc = "Show TODO comments (Trouble)",
			},
		},
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			require("tiny-inline-diagnostic").setup({
				preset = "minimal",
			})
			vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
		end,
	},
	{
		"linrongbin16/gitlinker.nvim",
		cmd = "GitLink",
		opts = {},
		keys = {
			{ "<leader>gl", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
		},
	},
	{
		"aznhe21/actions-preview.nvim",
		config = function()
			vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
		end,
	},
	{
		"ionide/Ionide-vim",
	},
})
