local mini_starter = require("mini.starter")

mini_starter.setup({
	items = {
		function()
			local session_path = vim.fn.stdpath("data") .. "/sessions" .. vim.fn.getcwd()
			local ok, _ = pcall(vim.fn.readfile, session_path)
			if ok then
				return {
					{
						action = function()
							print(" ") -- Clear the output
							require("sessions").load(session_path)
						end,
						name = "Load session",
						section = "Session Loader",
					},
				}
			end
		end,

		mini_starter.sections.recent_files(5, false, false),
		mini_starter.sections.builtin_actions,
	},
})
