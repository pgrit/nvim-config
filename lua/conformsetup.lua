require("conform").setup({
    formatters = {
        csharpier = {
            command = "csharpier",
            args = { "format", "$FILENAME", "--write-stdout" },
        }
    },
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		cs = { "csharpier", lsp_format = "fallback" },
	},
})
