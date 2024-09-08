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

	-- local width = vim.api.nvim_win_get_width(0)
	-- local r, c = unpack(vim.api.nvim_win_get_cursor(0))
	-- if r >= width then
	-- 	local keys = vim.api.nvim_replace_termcodes("0", true, false, true)
	-- 	vim.api.nvim_feedkeys(keys, "n", false)
	-- end
end)
-- vim.keymap.set("n", "<leader>F", ":Format<CR>")
-- vim.keymap.set("n", "<leader>f", function()
-- 	vim.cmd([[Format]])
-- 	vim.cmd.w()
-- end)

-- Autosessions
vim.keymap.set("n", "<leader>ms", function()
	local session_path = vim.fn.stdpath("cache") .. "/sessions" .. vim.fn.getcwd()
	require("sessions").save(session_path)
end)
vim.keymap.set("n", "<leader>ml", function()
	local session_path = vim.fn.stdpath("cache") .. "/sessions" .. vim.fn.getcwd()
	local ok, _ = pcall(vim.fn.readfile, session_path)
	if ok then
		require("sessions").load(session_path)
	else
		print("no session at this path")
	end
end)
vim.api.nvim_create_user_command("TrySessionsLoadCwd", function()
	local session_path = vim.fn.stdpath("cache") .. "/sessions" .. vim.fn.getcwd()
	local ok, _ = pcall(vim.fn.readfile, session_path)
	if ok then
		require("sessions").load(session_path)
	end
end, {})
vim.api.nvim_create_user_command("SessionsLoadCwd", function()
	local session_path = vim.fn.stdpath("cache") .. "/sessions" .. vim.fn.getcwd()
	local ok, _ = pcall(vim.fn.readfile, session_path)
	if ok then
		require("sessions").load(session_path)
	else
		error("\n\nError when loading session. Session file doesn't exist\nCreate session file with `<leader>ms`\n")
	end
end, {})

-- Paste below
vim.keymap.set("n", "<C-p>", "o<Esc>p")

-- Tree explorer
-- vim.keymap.set("n", "<C-b>", vim.cmd.NvimTreeFocus)

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
