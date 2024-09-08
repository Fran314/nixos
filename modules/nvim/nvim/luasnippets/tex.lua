local has_treesitter, ts = pcall(require, "vim.treesitter")

local MATH_ENVIRONMENTS = {
	displaymath = true,
	equation = true,
	eqnarray = true,
	align = true,
	math = true,
	array = true,
}
local MATH_NODES = {
	displayed_equation = true,
	inline_formula = true,
}

local function get_node_at_cursor()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local cursor_range = { cursor[1] - 1, cursor[2] }
	local buf = vim.api.nvim_get_current_buf()
	local ok, parser = pcall(ts.get_parser, buf, "latex")
	if not ok or not parser then
		return
	end
	local root_tree = parser:parse()[1]
	local root = root_tree and root_tree:root()

	if not root then
		return
	end

	return root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
end

local function in_comment()
	if has_treesitter then
		local node = get_node_at_cursor()
		while node do
			if node:type() == "comment" then
				return true
			end
			node = node:parent()
		end
		return false
	end
end

-- https://github.com/nvim-treesitter/nvim-treesitter/issues/1184#issuecomment-830388856
local function in_mathzone()
	if has_treesitter then
		local buf = vim.api.nvim_get_current_buf()
		local node = get_node_at_cursor()
		while node do
			if MATH_NODES[node:type()] then
				return true
			elseif node:type() == "math_environment" or node:type() == "generic_environment" then
				local begin = node:child(0)
				local names = begin and begin:field("name")
				if names and names[1] and MATH_ENVIRONMENTS[ts.get_node_text(names[1], buf):match("[A-Za-z]+")] then
					return true
				end
			end
			node = node:parent()
		end
		return false
	end
end

local function is_empty_buffer()
	-- local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	-- for i = 1, #lines do
	-- 	if lines[i] ~= "" then
	-- 		return false
	-- 	end
	-- end
	--
	return true
end

--- SNIPPETS ---
local snippets = {
	s({ trig = "beg", dscr = "begin and end specified environment" }, {
		t("\\begin{"),
		i(1, "environment"),
		t({ "}", "\t" }),
		i(0),
		t({ "", "\\end{" }),
		rep(1),
		t("}"),
	}),

	s({ trig = "fig", dscr = "figure environment" }, {
		t({ "\\begin{figure}[h]", "\t\\centering", "\\includegraphics[width=0.8\\textwidth]{" }),
		i(0, "figure"),
		t({ "}", "\\end{figure}" }),
	}),

	s("ket", { t("\\ket{"), i(1), t("}") }),
	s("braket", { t("\\braket{"), i(1), t("}{"), i(2), t("}") }),
	s("ketbra", { t("\\ket{"), i(1), t("}\\bra{"), i(2), t("}") }),

	s("mm", { t("$"), i(0), t("$") }),
	s("mmm", { t({ "\\[", "\t" }), i(0), t({ "", "\\]" }) }),

	s("bb", { t("\\mathbb{"), i(0), t("}") }),
	s("mb", { t("$\\mathbb{"), i(0), t("}$") }),
	s("cl", { t("\\mathcal{"), i(0), t("}") }),
	s("mc", { t("$\\mathcal{"), i(0), t("}$") }),

	s("tt", { t("\\text{"), i(0), t("}") }),

	s("impl", t("\\Rightarrow")),
	s("plim", t("\\Leftarrow")),

	s("lim", { t("\\lim_{"), i(1), t(" \to "), i(0), t("} ") }),
	s("liminf", { t("\\liminf_{"), i(1), t(" \to "), i(0), t("} ") }),
	s("limsup", { t("\\limsup_{"), i(1), t(" \to "), i(0), t("} ") }),

	s("int", { t("\\int_{"), i(1), t("}^{"), i(2), t("} "), i(0), t(" \\, dx") }),
	s("iint", { t("\\iint_{"), i(1), t("}^{"), i(2), t("} "), i(0), t(" \\, dx \\, dy") }),
	s("iiint", { t("\\iiint_{"), i(1), t("}^{"), i(2), t("} "), i(0), t(" \\, dx, \\, dy \\, dz") }),

	s("sum", { t("\\sum_{"), i(1), t("}^{"), i(0), t("} ") }),
	s("prod", { t("\\prod_{"), i(1), t("}^{"), i(0), t("} ") }),

	s("inv", t("^{-1}")),

	s("sqrt", { t("\\sqrt{"), i(0), t("}") }),

	s("alpha", t("\\alpha")),
	s("beta", t("\\beta")),
	s("gamma", t("\\gamma")),
	s("delta", t("\\delta")),
	s("epsilon", t("\\varepsilon")),
	s("zeta", t("\\zeta")),
	s("eta", t("\\eta")),
	s("theta", t("\\theta")),
	s("vartheta", t("\\vartheta")),
	s("gamma", t("\\gamma")),
	s("kappa", t("\\kappa")),
	s("lambda", t("\\lambda")),
	s("mu", t("\\mu")),
	s("nu", t("\\nu")),
	s("xi", t("\\xi")),
	s("pi", t("\\pi")),
	s("rho", t("\\rho")),
	s("sigma", t("\\sigma")),
	s("tau", t("\\tau")),
	s("upsilon", t("\\upsilon")),
	-- s("phi", t("\\phi")),
	-- s("varphi", t("\\varphi")),
	-- s("psi", t("\\psi")),
	s("omega", t("\\omega")),
	s("Gamma", t("\\Gamma")),
	s("Delta", t("\\Delta")),
	s("Theta", t("\\Theta")),
	s("Lambda", t("\\Lambda")),
	s("Xi", t("\\Xi")),
	s("Pi", t("\\Pi")),
	s("Sigma", t("\\Sigma")),
	s("Upsilon", t("\\Upsilon")),
	-- s("Phi", t("\\Phi")),
	-- s("Psi", t("\\Psi")),
	s("Omega", t("\\Omega")),

	-- s(
	-- 	{ trig = "m(%l)bf", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return "$\\mathbf{" .. snip.captures[1] .. "}$"
	-- 	end)
	-- ),
	-- s(
	-- 	{ trig = "m(%l)bf(%w)", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return "$\\mathbf{" .. snip.captures[1] .. "}_{" .. snip.captures[2] .. "}$"
	-- 	end)
	-- ),
	-- s(
	-- 	{ trig = "m(%l)bf(%w)(%w)", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return "$\\mathbf{" .. snip.captures[1] .. "}_{" .. snip.captures[2] .. "_{" .. snip.captures[3] .. "}}$"
	-- 	end)
	-- ),
	-- s(
	-- 	{ trig = "m(%l)", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return "$" .. snip.captures[1] .. "$"
	-- 	end)
	-- ),
	-- s(
	-- 	{ trig = "m(%l)(%w)", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return "$" .. snip.captures[1] .. "_{" .. snip.captures[2] .. "}$"
	-- 	end)
	-- ),
	-- s(
	-- 	{ trig = "m(%l)(%w)(%w)", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return "$" .. snip.captures[1] .. "_{" .. snip.captures[2] .. "_{" .. snip.captures[3] .. "}}$"
	-- 	end)
	-- ),
	--
	-- s({ trig = "m(%u)cal", regTrig = true, hidden = true }, {
	-- 	f(function(_, snip)
	-- 		return "$\\mathcal{" .. snip.captures[1] .. "}$"
	-- 	end),
	-- }),
	-- s({ trig = "m(%u)cal(%w)", regTrig = true, hidden = true }, {
	-- 	f(function(_, snip)
	-- 		return "$\\mathcal{" .. snip.captures[1] .. "}^{" .. snip.captures[2] .. "}$"
	-- 	end),
	-- }),
	-- s(
	-- 	{ trig = "m(%u)cal(%w)(%w)", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return "$\\mathcal{"
	-- 			.. snip.captures[1]
	-- 			.. "}^{"
	-- 			.. snip.captures[2]
	-- 			.. " \\times "
	-- 			.. snip.captures[3]
	-- 			.. "}$"
	-- 	end)
	-- ),
	-- s({ trig = "m(%u)", regTrig = true, hidden = true }, {
	-- 	f(function(_, snip)
	-- 		return "$\\mathbb{" .. snip.captures[1] .. "}$"
	-- 	end),
	-- }),
	-- s({ trig = "m(%u)(%w)", regTrig = true, hidden = true }, {
	-- 	f(function(_, snip)
	-- 		return "$\\mathbb{" .. snip.captures[1] .. "}^{" .. snip.captures[2] .. "}$"
	-- 	end),
	-- }),
	-- s(
	-- 	{ trig = "m(%u)(%w)(%w)", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return "$\\mathbb{"
	-- 			.. snip.captures[1]
	-- 			.. "}^{"
	-- 			.. snip.captures[2]
	-- 			.. " \\times "
	-- 			.. snip.captures[3]
	-- 			.. "}$"
	-- 	end)
	-- ),

	-- s(
	-- 	{ trig = "(%l)bf", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return "\\mathbf{" .. snip.captures[1] .. "}"
	-- 	end)
	-- ),
	-- s(
	-- 	{ trig = "(%l)bf(%w)", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return "\\mathbf{" .. snip.captures[1] .. "}_{" .. snip.captures[2] .. "}"
	-- 	end)
	-- ),
	-- s(
	-- 	{ trig = "(%l)bf(%w)(%w)", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return "\\mathbf{" .. snip.captures[1] .. "}_{" .. snip.captures[2] .. "_{" .. snip.captures[3] .. "}}"
	-- 	end)
	-- ),
	-- s(
	-- 	{ trig = "(%l)(%w)", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return snip.captures[1] .. "_{" .. snip.captures[2] .. "}"
	-- 	end)
	-- ),
	-- s(
	-- 	{ trig = "(%l)(%w)(%w)", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return snip.captures[1] .. "_{" .. snip.captures[2] .. "_{" .. snip.captures[3] .. "}}"
	-- 	end)
	-- ),
	--
	-- s({ trig = "(%u)cal", regTrig = true, hidden = true }, {
	-- 	f(function(_, snip)
	-- 		return "\\mathcal{" .. snip.captures[1] .. "}"
	-- 	end),
	-- }),
	-- s({ trig = "(%u)cal(%w)", regTrig = true, hidden = true }, {
	-- 	f(function(_, snip)
	-- 		return "\\mathcal{" .. snip.captures[1] .. "}^{" .. snip.captures[2] .. "}"
	-- 	end),
	-- }),
	-- s(
	-- 	{ trig = "(%u)cal(%w)(%w)", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return "\\mathcal{"
	-- 			.. snip.captures[1]
	-- 			.. "}^{"
	-- 			.. snip.captures[2]
	-- 			.. " \\times "
	-- 			.. snip.captures[3]
	-- 			.. "}"
	-- 	end)
	-- ),
	-- s({ trig = "(%u)(%w)", regTrig = true, hidden = true }, {
	-- 	f(function(_, snip)
	-- 		return "\\mathbb{" .. snip.captures[1] .. "}^{" .. snip.captures[2] .. "}"
	-- 	end),
	-- }),
	-- s(
	-- 	{ trig = "(%u)(%w)(%w)", regTrig = true, hidden = true },
	-- 	f(function(_, snip)
	-- 		return "\\mathbb{"
	-- 			.. snip.captures[1]
	-- 			.. "}^{"
	-- 			.. snip.captures[2]
	-- 			.. " \\times "
	-- 			.. snip.captures[3]
	-- 			.. "}"
	-- 	end)
	-- ),

	s(
		{ trig = "([%d%w]+)/([%d%w]+)", regTrig = true, hidden = true },
		f(function(_, snip)
			return "\\frac{" .. snip.captures[1] .. "}{" .. snip.captures[2] .. "}"
		end)
	),
	s({ trig = "/(%[%d%w]+)", regTrig = true, hidden = true }, {
		t("\\frac{"),
		i(0),
		f(function(_, snip)
			return "}{" .. snip.captures[1] .. "}"
		end),
	}),
	s({ trig = "([%d%w]+)/", regTrig = true, hidden = true }, {
		f(function(_, snip)
			return "\\frac{" .. snip.captures[1] .. "}{"
		end),
		i(0),
		t("}"),
	}),
	s({ trig = "/", hidden = true }, { t("\\frac{"), i(1), t("}{"), i(0), t("}") }),
	s(
		{ trig = "(%d+)x(%d+)", regTrig = true, hidden = true },
		d(1, function(_, snip)
			local rows = tonumber(snip.captures[1])
			local columns = tonumber(snip.captures[2])
			local nodes = { t({ "\\begin{pmatrix}", "\t" }) }
			for r = 1, rows do
				for c = 1, columns - 1 do
					table.insert(nodes, i((r - 1) * columns + c))
					table.insert(nodes, t(" & "))
				end
				table.insert(nodes, i(r * columns))
				if r < rows then
					table.insert(nodes, t({ "\\\\", "\t" }))
				end
			end
			table.insert(nodes, t({ "", "\\end{pmatrix}" }))
			return sn(nil, nodes)
		end),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "b(%d+)x(%d+)", regTrig = true, hidden = true },
		d(1, function(_, snip)
			local rows = tonumber(snip.captures[1])
			local columns = tonumber(snip.captures[2])
			local nodes = { t({ "\\begin{bmatrix}", "\t" }) }
			for r = 1, rows do
				for c = 1, columns - 1 do
					table.insert(nodes, i((r - 1) * columns + c))
					table.insert(nodes, t(" & "))
				end
				table.insert(nodes, i(r * columns))
				if r < rows then
					table.insert(nodes, t({ "\\\\", "\t" }))
				end
			end
			table.insert(nodes, t({ "", "\\end{bmatrix}" }))
			return sn(nil, nodes)
		end)
	),
	s(
		{ trig = "(%d+)t", regTrig = true, hidden = true },
		d(1, function(_, snip)
			local columns = tonumber(snip.captures[1])
			local nodes = { t("\\begin{bmatrix} ") }
			for r = 1, columns - 1 do
				table.insert(nodes, i(r))
				table.insert(nodes, t(" & "))
			end
			table.insert(nodes, i(columns))
			table.insert(nodes, t("\\end{bmatrix}^\\intercal"))
			return sn(nil, nodes)
		end)
	),
}

--- Programmatical snippets
local envs = {
	{ "ali", "align*" },
	{ "cas", "cases" },
	{ "enum", "enumerate" },
	{ "item", "itemize" },
	{ "eq", "equation*" },
	{ "frame", "frame" },
}
for _, env in ipairs(envs) do
	table.insert(
		snippets,
		s(env[1], {
			t({ "\\begin{" .. env[2] .. "}", "\t" }),
			i(0, ""),
			t({ "", "\\end{" .. env[2] .. "}" }),
		})
	)
end

local labelenvs = {
	{ "thm", "theorem" },
	{ "prop", "proposition" },
	{ "cor", "corollary" },
	{ "def", "definition" },
	{ "rem", "remark" },
	{ "lem", "lemma" },
}
for _, env in ipairs(labelenvs) do
	table.insert(
		snippets,
		s(env[1], {
			t({ "\\begin{" .. env[2] .. "}[" }),
			i(1, "label"),
			t({ "]", "\t" }),
			i(0, ""),
			t({ "", "\\end{" .. env[2] .. "}" }),
		})
	)
end

local graphlabelenvs = {
	{ "block", "block" },
}
for _, env in ipairs(graphlabelenvs) do
	table.insert(
		snippets,
		s(env[1], {
			t({ "\\begin{" .. env[2] .. "}{" }),
			i(1, "label"),
			t({ "}", "\t" }),
			i(0, ""),
			t({ "", "\\end{" .. env[2] .. "}" }),
		})
	)
end

for _, R in ipairs({ "C", "R", "Q", "Z", "N", "H" }) do
	table.insert(snippets, s(R, t("\\mathbb{" .. R .. "}")))
end

--- Templates
local empty = [[
    \documentclass{article}
    \usepackage[italian]{babel}

    \title{<>}
    \author{<>}
    \date{<>}

    \begin{document}

    \maketitle

    \tableofcontents
    \section{<>}

    \end{document}
]]

local slide = [[
    \documentclass[8pt]{beamer}

    %--- STYLE ---%
    \usetheme{Dresden}
    \usecolortheme{spruce}
    \definecolor{MSUgreen}{RGB}{0,102,51}

    % Change institute color in footer to make it readable (green and darker)
    \setbeamercolor{institute in head/foot}{parent=palette primary}
    % Change title color in footer to make it readable (lighter)
    \setbeamercolor{title in head/foot}{fg=white!90!MSUgreen}

    % Remove the bottom right navigation symbols
    \setbeamertemplate{navigation symbols}{}

    % blocks
    \setbeamercolor{block title}{bg=white!70!MSUgreen,fg=MSUgreen!60!black}
    \setbeamercolor{block body}{bg=white!90!MSUgreen}

    % itemize style
    \setbeamercolor{itemize item}{fg=MSUgreen!80!black}
    \setbeamertemplate{itemize item}[circle]

    % enumerate style
    \setbeamercolor{enumerate item}{fg=MSUgreen!80!black}

    % Comic Neue
    \usepackage{fontspec}
    %--- ---%

    \title{<>}
    \subtitle{<>}
    \author{<>}
    \institute{Università di Pisa\\Dipartimento di Matematica}
    \date{<>}

    \begin{document}

        \frame{\titlepage}

        \begin{frame}{Slide esempio}
            \begin{block}{Blocco esempio}
                Testo del blocco esempio
            \end{block}

            \begin{itemize}
                \item Item A
                \item Item B
                \item Item C
            \end{itemize}

            \begin{enumerate}
                \item Item 1
                \item Item 2
                \item Item 3
            \end{enumerate}
        \end{frame}

        \begin{frame}{Fine}
            \begin{center}
                {
                    \Huge
                    Grazie per l'attenzione!
                }
            \end{center}
        \end{frame}
    \end{document}
]]

local listone = [[
    \documentclass{article}
    \usepackage[utf8]{inputenc}
    \usepackage[italian]{babel}
    \usepackage{amsmath}
    \usepackage{amsfonts}
    \usepackage{geometry}
    \geometry{
        a4paper,
        left=10mm,
        top=10mm,
        right=10mm,
        bottom=10mm
    }
    \usepackage{multicol}

    \begin{document}
    	\begin{center}
    		\Large <>\\ \vspace{0.8em}{\Huge <>}
    	\end{center}
    	\vspace{2em}
        \begin{multicols*}{2}
    		\begin{itemize}
      			\setlength\itemsep{-0.1em}
    			\section*{Sezione 1}
    			\item item 1
    			\item item 2
    			\item item 3
    			\section*{Sezione 2}
    			\item item 1
    			\item item 2
    			\item item 3
    		\end{itemize}
        \end{multicols*}
    \end{document}
]]

table.insert(
	snippets,
	s(
		"empty",
		fmt(empty, {
			i(1, "Titolo"),
			i(2, "Autore"),
			i(3, "Data"),
			i(4, "Introduzione"),
		}, {
			delimiters = "<>",
		}),
		{ condition = is_empty_buffer }
	)
)
table.insert(
	snippets,
	s(
		"slide",
		fmt(slide, {
			i(1, "Titolo"),
			i(2, "Sottotitolo"),
			i(3, "Nome Cognome"),
			i(4, "Data"),
		}, {
			delimiters = "<>",
		})
	)
)
table.insert(
	snippets,
	s(
		"listone",
		fmt(listone, {
			i(1, "Listone di Baldo di"),
			i(2, "Nome della materia"),
		}, {
			delimiters = "<>",
		})
	)
)

--- AUTOSNIPPETS ---
local autosnippets = {
	s({ trig = "__", wordTrig = false }, { t("_{"), i(1), t("}") }),
	s({ trig = "^^", wordTrig = false }, { t("^{"), i(1), t("}") }),
	s({ trig = ">=", wordTrig = false }, t("\\geq ")),
	s({ trig = "<=", wordTrig = false }, t("\\leq ")),
	s("htoh", t("\\mathbb{H} \\to \\mathbb{H}")),
	s("xx", t("\\times")),
	s("ox", t("\\otimes")),
	s("...", t("\\dots")),
	s({ trig = "TT", wordTrig = false }, t("^\\intercal")),
	s("psi", t("\\psi")),
	s("phi", t("\\varphi")),
}

--- Programmatical autosnippets
for _, x in ipairs({ { "(", ")" }, { "[", "]" }, { "{", "}" } }) do
	table.insert(autosnippets, s("lr" .. x[1], { t("\\left" .. x[1]), i(0), t("\\right" .. x[2]) }))
end

--- RETURN ---
return snippets, autosnippets

