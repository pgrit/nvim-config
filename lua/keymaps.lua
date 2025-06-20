-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

-----------------
-- Normal mode --
-----------------

-- Hint: see `:h vim.map.set()`
-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-----------------
-- Debug mode --
-----------------

vim.keymap.set('n', '<F5>', (function () require'dap'.continue() end), opts)
vim.keymap.set('n', '<F10>', (function () require'dap'.step_over() end), opts)
vim.keymap.set('n', '<F11>', (function () require'dap'.step_into() end), opts)
vim.keymap.set('n', '<F9>', (function () require'dap'.toggle_breakpoint() end), opts)
vim.keymap.set('n', '<Leader>dr', (function () require'dap'.repl.open() end), opts)
vim.keymap.set('n', '<Leader>do', (function () require'dapui'.open() end), opts)
vim.keymap.set('n', '<Leader>dc', (function () require'dapui'.close() end), opts)

-------------------------
-- Diagnostics and LSP --
-------------------------

vim.keymap.set("n", "<F1>", function() vim.diagnostic.open_float() end, opts)
