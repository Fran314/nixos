------- BOOTSTRAP LAZY -------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
------------------------------
--

---------- OPTIONS -----------
-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = " "

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- vim.opt.colorcolumn = "80"

vim.o.fillchars = "eob: "
------------------------------
--

------------ LAZY ------------
require("lazy").setup({
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "macchiato",
			transparent_background = true,
		},
		init = function()
			vim.cmd.colorscheme("catppuccin")
		end,
		-- config = function()
		-- 	require("catppuccin").setup({
		-- 		flavour = "macchiato",
		-- 		transparent_background = true,
		-- 	})
		-- 	vim.cmd.colorscheme("catppuccin")
		-- end,
	},

	-- {
	-- 	"nvim-telescope/telescope.nvim",
	-- 	branch = "0.1.x",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- 	keys = {
	-- 		{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "[S]earch [F]iles" },
	-- 		{ "<leader>sg", "<cmd>Telescope git_files<cr>", desc = "[S]earch [G]it files" },
	-- 		{ "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch current [W]ord" },
	-- 		{ "<leader>st", "<cmd>Telescope live_grep<cr>", desc = "[S]earch [T]ext" },
	-- 		{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch [D]iagnostics" },
	-- 	},
	-- 	opts = {
	-- 		pickers = {
	-- 			find_files = {
	-- 				hidden = true,
	-- 			},
	-- 			live_grep = {
	-- 				additional_args = function(opts)
	-- 					return { "--hidden" }
	-- 				end,
	-- 			},
	-- 		},
	-- 		defaults = {
	-- 			file_ignore_patterns = {
	-- 				".git",
	-- 				"node_modules", -- for nodejs projects
	-- 				"target", -- for rust projects
	-- 			},
	-- 		},
	-- 		extensions = {
	-- 			fzf = {
	-- 				fuzzy = true,
	-- 				override_generic_sorter = true,
	-- 				override_file_sorter = true,
	-- 				case_mode = "smart_case",
	-- 			},
	-- 		},
	-- 	},
	-- 	-- config = function()
	-- 	-- 	require("telescope").setup({
	-- 	-- 		defaults = {
	-- 	-- 			file_ignore_patterns = {
	-- 	-- 				"node_modules", -- for nodejs projects
	-- 	-- 				"target", -- for rust projects
	-- 	-- 			},
	-- 	-- 		},
	-- 	-- 		extensions = {
	-- 	-- 			fzf = {
	-- 	-- 				fuzzy = true,
	-- 	-- 				override_generic_sorter = true,
	-- 	-- 				override_file_sorter = true,
	-- 	-- 				case_mode = "smart_case",
	-- 	-- 			},
	-- 	-- 		},
	-- 	-- 	})
	-- 	-- end,
	-- },
	-- {
	-- 	"nvim-telescope/telescope-fzf-native.nvim",
 --        build = "make",
	-- 	-- build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	-- 	init = function()
	-- 		require("telescope").load_extension("fzf")
	-- 	end,
	-- 	-- config = function()
	-- 	-- 	require("telescope").load_extension("fzf")
	-- 	-- end,
	-- },

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			-- A list of parser names, or "all"
			ensure_installed = { "javascript", "typescript", "c", "lua", "rust", "haskell" },

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			highlight = {
				-- `false` will disable the whole extension
				enable = true,

				-- disable = { "latex" },

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<c-space>",
					node_incremental = "<c-space>",
					scope_incremental = "<c-s>",
					node_decremental = "<c-backspace>",
				},
			},

			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- LSP plugins
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		opts = {
			window = {
				blend = 0,
			},
			fmt = {
				stack_upwards = false,
				max_width = 200,
				-- function to format each task line
				task = function(task_name, message, percentage)
					local short_task_name = task_name
					if task_name ~= nil and string.len(task_name) > 20 then
						short_task_name = string.sub(task_name, 1, 17) .. "..."
					end
					return string.format(
						"[%s] %s%s",
						short_task_name,
						message,
						percentage and string.format(" (%s%%)", percentage) or ""
					)
				end,
			},
		},
		-- config = function()
		-- 	require("fidget").setup({
		-- 		window = {
		-- 			blend = 0,
		-- 		},
		-- 		fmt = {
		-- 			stack_upwards = false,
		-- 			max_width = 200,
		-- 			-- function to format each task line
		-- 			task = function(task_name, message, percentage)
		-- 				local short_task_name = task_name
		-- 				if task_name ~= nil and string.len(task_name) > 20 then
		-- 					short_task_name = string.sub(task_name, 1, 17) .. "..."
		-- 				end
		-- 				return string.format(
		-- 					"[%s] %s%s",
		-- 					short_task_name,
		-- 					message,
		-- 					percentage and string.format(" (%s%%)", percentage) or ""
		-- 				)
		-- 			end,
		-- 		},
		-- 	})
		-- end,
	},
	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			-- "williamboman/mason.nvim",
			-- "williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			"j-hui/fidget.nvim",

			-- Additional lua configuration, makes nvim stuff amazing
			"folke/neodev.nvim",
		},
	},
	-- {
	-- 	"nvimtools/none-ls.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- },
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	-- { "mhartington/formatter.nvim" },
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
	},
	{
		"weilbith/nvim-code-action-menu",
		cmd = "CodeActionMenu",
		keys = {
			{ "<C-f>", vim.cmd.CodeActionMenu },
		},
	},

	{
		"numToStr/Comment.nvim",
		config = true,
		-- config = function()
		-- 	require("Comment").setup()
		-- end,
	},

	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				-- icons_enabled = false,
				theme = "catppuccin",
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_c = {
					{
						"filename",
						file_status = true,
						path = 1,
					},
				},
			},
		},
		-- config = function()
		-- 	require("lualine").setup({
		-- 		options = {
		-- 			-- icons_enabled = false,
		-- 			theme = "catppuccin",
		-- 			component_separators = "|",
		-- 			section_separators = "",
		-- 		},
		-- 		sections = {
		-- 			lualine_c = {
		-- 				{
		-- 					"filename",
		-- 					file_status = true,
		-- 					path = 1,
		-- 				},
		-- 			},
		-- 		},
		-- 	})
		-- end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = true,
		-- config = function()
		-- 	require("ibl").setup({})
		-- end,
	},

	{
		"nvim-tree/nvim-web-devicons",
	},
	{
		"romgrk/barbar.nvim",
		dependencies = { "nvim-web-devicons" },
	},

	-- { "tpope/vim-fugitive" }, -- for :Git command
	{
		"lewis6991/gitsigns.nvim",
		config = true,
		-- config = function()
		-- 	require("gitsigns").setup()
		-- end,
	},

	{
		"windwp/nvim-autopairs",
		config = true,
		-- config = function()
		-- 	require("nvim-autopairs").setup({})
		-- end,
	},

	{
		"norcalli/nvim-colorizer.lua",
		config = true,
		-- config = function()
		-- 	require("colorizer").setup()
		-- end,
	},

	{
		"echasnovski/mini.starter",
		version = "*",
		config = true,
		-- config = function()
		-- 	require("mini.starter").setup()
		-- end,
	},
	-- {
	-- 	"goolord/alpha-nvim",
	-- 	config = function()
	-- 		local heading = {
	-- 			type = "text",
	-- 			val = "· Today is nice ·",
	-- 			opts = {
	-- 				position = "center",
	-- 				hl = "Folded",
	-- 			},
	-- 		}
	-- 		local config = { layout = { heading } }
	-- 		require("alpha").setup(config)
	-- 	end,
	-- },

	{
		"natecraddock/sessions.nvim",
		lazy = false,
		opts = {
			session_filepath = vim.fn.stdpath("data") .. "/sessions",
			absolute = true,
		},
		-- config = function()
		-- 	require("sessions").setup({
		-- 		session_filepath = vim.fn.stdpath("data") .. "/sessions",
		-- 		absolute = true,
		-- 	})
		-- end,
	},
	-- {
	-- 	"folke/persistence.nvim",
	-- 	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	-- 	opts = {
	-- 		-- add any custom options here
	-- 	},
	-- },
    {
        "Pocco81/auto-save.nvim",
        opts = {
            trigger_events = { "InsertLeave", "TextChanged", "WinClosed" }
        }
    }
})
------------------------------
--

------ PERSISTENT UNDO -------
vim.o.undofile = true
vim.opt.undodir = vim.fn.expand("~") .. "/.nvim/undo"
-- set undofile
-- set undodir="$XDG_DATA_HOME/nvim/undo"
------------------------------
--

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

-- Paste below
vim.keymap.set("n", "<C-p>", "o<Esc>p")

-- Load and save sessions
vim.keymap.set("n", "<leader>ms", ":SessionsSave! ~/.nvim/sessions/")
vim.keymap.set("n", "<leader>ml", ":SessionsLoad ~/.nvim/sessions/")

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

-------- COLORSCHEME ---------
vim.api.nvim_command("hi LineNr guifg=#BBBBBB")

vim.api.nvim_command("hi Normal guibg=NONE ctermbg=NONE")
vim.api.nvim_command("hi EndOfBuffer guibg=NONE ctermbg=NONE")
vim.api.nvim_command("hi SignColumn guibg=NONE ctermbg=NONE")
vim.api.nvim_command("hi BufferTabpageFill guibg=NONE ctermbg=NONE")
------------------------------
--

---------- AUTOWRAP ----------
local autowrap_group = vim.api.nvim_create_augroup("Markdown Wrap Settings", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.md",
	group = autowrap_group,
	command = "setlocal wrap",
})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.tex",
	group = autowrap_group,
	command = "setlocal wrap",
})
------------------------------
--

------------ LSP -------------
local on_attach_lsp = function(client, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	-- nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
	-- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	-- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	-- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	-- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	-- nmap('<leader>wl', function()
	--     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, '[W]orkspace [L]ist Folders')

	-- Create a command `:Format` local to the LSP buffer
	-- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
	--     vim.lsp.buf.format({})
	-- end, { desc = 'Format current buffer with LSP' })
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false
end

local servers = {
	-- See https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
	-- for all available LSPs

	-- clangd = {}, -- C & C++ lsp

	rust_analyzer = {
		["rust-analyzer"] = {
			checkOnSave = {
				allFeatures = true,
				overrideCommand = {
					"cargo",
					"clippy",
					"--message-format=json",
					"--workspace",
					"--all-targets",
					"--all-features",
				},
			},
		},
	}, -- Rust lsp

	-- pyright = {}, -- Python lsp
	--
	-- tsserver = {}, -- Typescript lsp
	-- volar = {}, -- Vue lsp
	-- cssls = {}, -- CSS lsp
	--
	-- texlab = {}, -- LaTeX lsp
	--
	-- -- hls = {},
	--
	-- lua_ls = {
	-- 	Lua = {
	-- 		diagnostics = {
	-- 			disable = { "undefined-global" },
	-- 		},
	-- 		workspace = { checkThirdParty = false },
	-- 		telemetry = { enable = false },
	-- 	},
	-- },
}

require("neodev").setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- require("mason").setup()
-- local mason_lspconfig = require("mason-lspconfig")
--
-- mason_lspconfig.setup({
-- 	ensure_installed = vim.tbl_keys(servers),
-- })
--
-- mason_lspconfig.setup_handlers({
-- 	function(server_name)
-- 		require("lspconfig")[server_name].setup({
-- 			capabilities = capabilities,
-- 			on_attach = on_attach_lsp,
-- 			settings = servers[server_name],
-- 		})
-- 	end,
-- })
local lspconfig = require("lspconfig")

for name, settings in pairs(servers) do
    lspconfig[name].setup({
		capabilities = capabilities,
		on_attach = on_attach_lsp,
		settings = settings,
	})

end

-- -- Utilities for creating configurations
-- local util = require("formatter.util")
--
-- -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
-- require("formatter").setup({
-- 	-- Enable or disable logging
-- 	logging = true,
-- 	-- Set the log level
-- 	log_level = vim.log.levels.WARN,
-- 	-- All formatter configurations are opt-in
-- 	filetype = {
-- 		-- Formatter configurations for filetype "lua" go here
-- 		-- and will be executed in order
-- 		lua = {
-- 			require("formatter.filetypes.lua").stylua,
-- 		},
--
-- 		["*"] = {
-- 			require("formatter.defaults.prettierd"),
-- 		},
-- 	},
-- })
local null_ls = require("null-ls")
local sources = {
	-- General purpose
	null_ls.builtins.formatting.prettierd.with({
		env = {
			PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/nvim/utils/linter-config/.prettierrc.json"),
		},
	}),

	null_ls.builtins.formatting.rustfmt,

	-- Lua
	null_ls.builtins.formatting.stylua,

	-- Haskell
	null_ls.builtins.formatting.fourmolu,
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

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")
luasnip.config.setup({
	enable_autosnippets = true,
	region_check_events = "InsertEnter",
	delete_check_events = "InsertLeave",
})
require("luasnip.loaders.from_lua").load()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-u>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = nil,
		-- ['<CR>'] = cmp.mapping.confirm {
		--   behavior = cmp.ConfirmBehavior.Replace,
		--   select = true,
		-- },
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({ select = true })
				-- cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<Esc>"] = cmp.mapping.close(),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.close()
				-- cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	completion = {
		completeopt = "menu,menuone,noinsert,noselect",
	},
	window = {
		documentation = cmp.config.window.bordered(),
		completion = cmp.config.window.bordered(),
		-- completion = { -- rounded border; thin-style scrollbar
		--     border = 'rounded',
		--     -- scrollbar = '║',
		-- },
		-- documentation = { -- no border; native-style scrollbar
		--     border = 'rounded',
		--     -- scrollbar = '',
		--     -- other options
		-- },
	},
	preselect = cmp.PreselectMode.None,
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
------------------------------
--

-- RESTORE CURSOR POSITION ---
vim.api.nvim_create_autocmd("BufRead", {
	callback = function(opts)
		vim.api.nvim_create_autocmd("BufWinEnter", {
			once = true,
			buffer = opts.buf,
			callback = function()
				local ft = vim.bo[opts.buf].filetype
				local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
				if
					not (ft:match("commit") and ft:match("rebase"))
					and last_known_line > 1
					and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
				then
					vim.api.nvim_feedkeys([[g`"]], "nx", false)
				end
			end,
		})
	end,
})
------------------------------

