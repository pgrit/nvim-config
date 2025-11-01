-- Remove Global Default Key mapping
vim.keymap.del("n", "grn")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gO")

-- Create keymapping
-- LspAttach: After an LSP Client performs "initialize" and attaches to a buffer.
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local keymap = vim.keymap
		local lsp = vim.lsp
		local bufopts = { noremap = true, silent = true }

		keymap.set("n", "gr", lsp.buf.references, bufopts)
		keymap.set("n", "gd", lsp.buf.definition, bufopts)

		vim.keymap.set("n", "]g", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end)
		vim.keymap.set("n", "[g", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end)

		keymap.set("n", "<F2>", lsp.buf.rename, bufopts)
		keymap.set("n", "K", function()
			lsp.buf.hover({ border = "rounded" })
		end, bufopts)
	end,
})

vim.lsp.config("tinymist", {
	on_attach = function(client, bufnr)
		vim.keymap.set("n", "<leader>tp", function()
			client:exec_cmd({
				title = "pin",
				command = "tinymist.pinMain",
				arguments = { vim.api.nvim_buf_get_name(0) },
			}, { bufnr = bufnr })
		end, { desc = "[T]inymist [P]in", noremap = true })
		vim.keymap.set("n", "<leader>tu", function()
			client:exec_cmd({
				title = "unpin",
				command = "tinymist.pinMain",
				arguments = { vim.v.null },
			}, { bufnr = bufnr })
		end, { desc = "[T]inymist [U]npin", noremap = true })
	end,
	settings = {
		formatterMode = "typstyle",
		-- specify local relative paths for fonts (must be consistent with preview setting & CLI args!)
		fontPaths = { "./fonts", "./common/fonts" },
	},
})

vim.lsp.config("pylsp", {
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					enabled = false,
					ignore = { "W391", "E302", "E275" },
					maxLineLength = 100,
				},
			},
		},
	},
})

vim.lsp.config("ltex", {
	settings = {
		ltex = {
			enabled = { "latex", "markdown" },
		},
	},
})

local hl = require("actions-preview.highlight")
require("actions-preview").setup({
	highlight_command = {
		hl.delta("delta --no-gitconfig"),
	},
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				-- Globals for neovim and plugins
				globals = { "vim", "Snacks" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files and plugins
				library = { vim.env.VIMRUNTIME },
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})
