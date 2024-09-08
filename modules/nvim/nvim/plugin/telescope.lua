require('telescope').setup({
    pickers = {
		find_files = {
			hidden = true,
		},
		live_grep = {
			additional_args = function(opts)
				return { "--hidden" }
			end,
		},
	},
    defaults = {
		file_ignore_patterns = {
            "%.git",
			"node_modules", -- for nodejs projects
			"target", -- for rust projects
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
vim.keymap.set('n', '<leader>sg', builtin.git_files, {})
vim.keymap.set('n', '<leader>st', builtin.live_grep, {})
vim.keymap.set('n', '<leader>sw', builtin.grep_string, {})
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

require('telescope').load_extension('fzf')
