local snippets = {}
local autosnippets = {
	-- Don't trigger this on single apostrophe because there are many cases
	-- where a single apostrophe is the intended behaviour
	s({ trig = "''", hidden = true, wordTrig = false }, { t("'"), i(0), t("'") }),
	s({ trig = "E'", hidden = true }, t("È")),
}

local open_close = {
	-- These first should be only for tex and plaintex. Fix this eventually
	{ "\\left(", "\\right" },
	{ "\\left[", "\\right" },
	{ "\\left{", "\\right" },
	{ "\\left|", "\\right|" },
	{ "\\(", "\\" },
	{ "\\[", "\\" },
	{ "\\{", "\\" },
	{ "\\|", "\\|" },
	--
	-- { "(", ")" },
	-- { "[", "]" },
	-- { "{", "}" },
	-- { '"', '"' },
	-- { "`", "`" },
}

for _, env in ipairs(open_close) do
	-- table.insert(
	-- 	autosnippets,
	-- 	s({ trig = "(.*)%" .. env[1], regTrig = true, hidden = true }, {
	-- 		d(1, function(_, snip)
	-- 			local prev = snip.captures[1]
	-- 			local succ = tostring(vim.api.nvim_get_current_line())
	-- 			local k = 0
	-- 			local is_excessive = false
	-- 			while k < #prev and string.sub(prev, #prev - k, #prev - k) == env[1] do
	-- 				if k + 1 > #succ or string.sub(succ, k + 1, k + 1) ~= env[2] then
	-- 					is_excessive = true
	-- 				end
	-- 				k = k + 1
	-- 			end
	-- 			if is_excessive then
	-- 				return sn(nil, { t(snip.captures[1]), i(1), t(env[2]) })
	-- 			else
	-- 				return sn(nil, { t(snip.captures[1] .. env[1]) })
	-- 			end
	-- 		end),
	-- 	})
	-- )

	table.insert(
		autosnippets,
		s({ trig = env[1], hidden = true, wordTrig = false }, {
			t(env[1]),
			i(0),
			t(env[2]),
		})
	)
end
return snippets, autosnippets

