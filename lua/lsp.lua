-- Remove Global Default Key mapping
vim.keymap.del("n", "grn")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gO")

-- Create keymapping
-- LspAttach: After an LSP Client performs "initialize" and attaches to a buffer.
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function (args)
        local keymap = vim.keymap
        local lsp = vim.lsp
	    local bufopts = { noremap = true, silent = true }

        keymap.set("n", "gr", lsp.buf.references, bufopts)
        keymap.set("n", "gd", lsp.buf.definition, bufopts)
        keymap.set("n", "<F2>", lsp.buf.rename, bufopts)
        keymap.set("n", "K", lsp.buf.hover, bufopts)
        keymap.set("n", "<space>f", function()
            require("conform").format({ async = true, lsp_fallback = true })
        end, bufopts)
    end
})

require("lspconfig")["tinymist"].setup { -- Alternatively, can be used `vim.lsp.config["tinymist"]`

    -- ...

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

}
