-- define common options
local opts = {
    noremap = true,  -- non-recursive
    silent = true,   -- do not show message
}

-----------------------------
-- General editor commands --
-----------------------------

local function map(mode, shortcut, command)
    vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

map("n", "<Home>", "^")
map("v", "<Home>", "^")
map("i", "<Home>", "<Esc>^i")

-- Shortcut to clear search results
vim.keymap.set("n", "<Leader>c", ':let @/ = ""<CR>', opts)

-----------------
-- Normal mode --
-----------------

-- Hint: see `:h vim.map.set()`
-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-----------------
-- Visual mode --
-----------------

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-------------------------
-- Diagnostics and LSP --
-------------------------

vim.keymap.set("n", "<F1>", function()
    vim.diagnostic.open_float()
end, opts)

vim.keymap.set({ "n", "v" }, "<C-f>", function()
    require("conform").format({ async = true, lsp_fallback = true })
end)

--------------------------
-- IDE-like functions   --
--------------------------

-- Build .NET project
vim.keymap.set("n", "<C-b>", ":!dotnet build<CR>", opts)

-- Compile typst document to .svg and copy the resulting file
-- This currently only works on Linux with Wayland
vim.keymap.set("n", "<Leader>tc", function()
    local fname = vim.api.nvim_buf_get_name(0)
    local mktmp = "svgdir=$(mktemp -d)"
    local typst = "typst c " .. fname .. " --format svg ${svgdir}/img.svg"
    local copy = "wl-copy file://${svgdir}/img.svg -t text/uri-list"
    os.execute(mktmp .. " && " .. typst .. " && " .. copy)
end, opts)

--------------------------
-- QoL plugins triggers --
--------------------------

vim.keymap.set("n", "<Leader>e", function()
    Snacks.explorer()
end, opts)
vim.keymap.set("n", "<Leader>g", function()
    Snacks.lazygit()
end, opts)
vim.keymap.set("n", "<Leader>gg", function()
    Snacks.lazygit()
end, opts)
vim.keymap.set({ "n", "v" }, "<Leader>h", function()
    Snacks.notifier.show_history()
end, opts)

vim.keymap.set("n", "<Leader>`", function()
    Snacks.terminal()
end, opts)
