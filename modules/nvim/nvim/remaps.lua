----------- REMAPS -----------
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer" })

-- Allow to move and auto indent selected block
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Allow search term to stay in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "[P]aste without losing copied text" })

-- Tab managing
vim.keymap.set({ "n", "t", "i" }, "<C-right>", vim.cmd.BufferNext)
vim.keymap.set({ "n", "t", "i" }, "<C-left>", vim.cmd.BufferPrevious)
vim.keymap.set({ "n", "t", "i" }, "<C-l>", vim.cmd.BufferNext)
vim.keymap.set({ "n", "t", "i" }, "<C-h>", vim.cmd.BufferPrevious)
vim.keymap.set({ "n", "t", "i" }, "<C-S-right>", vim.cmd.BufferMoveNext)
vim.keymap.set({ "n", "t", "i" }, "<C-S-left>", vim.cmd.BufferMovePrevious)
vim.keymap.set({ "n", "t", "i" }, "<C-down>", vim.cmd.BufferClose)

-- Diagnostics
local diagnostic_ops = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, diagnostic_ops)
-- Useful but I need to find a better remap
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, diagnostic_ops)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, diagnostic_ops)

-- Format
vim.keymap.set("n", "<leader>F", vim.lsp.buf.format)
vim.keymap.set("v", "<leader>f", function()
	vim.lsp.buf.format()
	vim.cmd.w()

	local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "x", false)
end)
vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.format()
	vim.cmd.w()
end)

-- Paste below
vim.keymap.set("n", "<C-p>", "o<Esc>p")

-- Make current buffer executable
vim.keymap.set("n", "<C-x>", ":!chmod +x %<CR><CR>")

-- Un/set wrap
vim.keymap.set("n", "<leader>ww", function()
	vim.cmd([[ set wrap ]])
end)
vim.keymap.set("n", "<leader>wn", function()
	vim.cmd([[ set nowrap ]])
end)
------------------------------
--
