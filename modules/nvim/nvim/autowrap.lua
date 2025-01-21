---------- AUTOWRAP ----------
local autowrap_group = vim.api.nvim_create_augroup("Auto Wrap Settings", { clear = true })

-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	pattern = "*.md",
-- 	group = autowrap_group,
-- 	command = "setlocal wrap",
-- })
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.tex",
	group = autowrap_group,
	command = "setlocal wrap",
})
------------------------------
--
