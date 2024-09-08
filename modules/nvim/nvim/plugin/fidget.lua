require("fidget").setup({
    notification = {
        window = {
            winblend = 0,
            max_width = 200,
        },
        view = {
            stack_upwards = false,
        }
    }

    -- -- TODO capire come risolvere questo
	-- fmt = {
	-- 	-- function to format each task line
	-- 	task = function(task_name, message, percentage)
	-- 		local short_task_name = task_name
	-- 		if task_name ~= nil and string.len(task_name) > 20 then
	-- 			short_task_name = string.sub(task_name, 1, 17) .. "..."
	-- 		end
	-- 		return string.format(
	-- 			"[%s] %s%s",
	-- 			short_task_name,
	-- 			message,
	-- 			percentage and string.format(" (%s%%)", percentage) or ""
	-- 		)
	-- 	end,
	-- },
})
