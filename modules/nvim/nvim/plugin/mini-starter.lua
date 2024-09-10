local mini_starter = require("mini.starter")

mini_starter.setup({
	items = {
		mini_starter.sections.recent_files(5, false, false),
		mini_starter.sections.builtin_actions,
	},
	footer = "",
})
