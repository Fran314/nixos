local null_ls = require("null-ls")
local sources = {
	-- General purpose
	null_ls.builtins.formatting.prettierd.with({
	    filetypes = {},
		env = {
			PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/nvim/utils/linter-config/.prettierrc.json"),
		},
	}),

	null_ls.builtins.formatting.rustfmt,

	-- Lua
	null_ls.builtins.formatting.stylua,
}

null_ls.setup({
	sources = sources,
})
null_ls.register({
	name = "my-todo-reminder",
	method = null_ls.methods.DIAGNOSTICS,
	filetypes = {},
	generator = {
		fn = function(params)
			local out = {}
			for i, line in ipairs(params.content) do
				local match = line:match(".*TODO.*")
				if match then
					table.insert(out, {
						row = i,
						message = "Remember to do this TODO",
						severity = vim.diagnostic.severity.WARN,
					})
				end
			end

			return out
		end,
	},
})
