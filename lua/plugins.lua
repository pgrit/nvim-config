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

require("lazy").setup({
	"tanvirtin/monokai.nvim",
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },

		version = "*",

		opts = {
			keymap = {
				preset = "super-tab",
				-- Select completions
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				-- Scroll documentation
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				-- Show/hide signature
				["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
			completion = {
				-- The keyword should only match against the text before
				keyword = { range = "prefix" },
				menu = {
					-- Use treesitter to highlight the label text for the given list of sources
					draw = {
						treesitter = { "lsp" },
					},
				},
				-- Show completions after typing a trigger character, defined by the source
				trigger = { show_on_trigger_character = true },
				documentation = {
					-- Show documentation automatically
					auto_show = true,
				},
			},

			-- Signature help when typing
			signature = { enabled = true },
		},
		opts_extend = { "sources.default" },
	},
	{ "mason-org/mason.nvim", opts = {} },
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = { "pylsp", "ts_ls", "csharp_ls", "tinymist" },
		},
	},
	{ "nvim-telescope/telescope.nvim" },
	{
		"chomosuke/typst-preview.nvim",
		lazy = false, -- or ft = 'typst'
		version = "1.*",
		opts = {}, -- lazy.nvim will implicitly calls `setup {}`
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
	{ "tpope/vim-fugitive" },
	{ "lewis6991/gitsigns.nvim" },
	{
		"wfxr/minimap.vim",
		init = function()
			vim.g.minimap_width = 5
			-- vim.g.minimap_auto_start = 1
			-- vim.g.minimap_highlight_search = 1
			-- vim.g.minimap_git_colors = 1
		end,
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
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			require("tiny-inline-diagnostic").setup()
			vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
		end,
	},
	{
		"linrongbin16/gitlinker.nvim",
		cmd = "GitLink",
		opts = {},
		keys = {
			{ "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
		},
	},
})
