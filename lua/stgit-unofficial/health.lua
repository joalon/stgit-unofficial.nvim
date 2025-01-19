local M = {}

M.check = function()
	vim.health.start("stgit report")

	local executables = { "stg", "git" }

	for _, exe in ipairs(executables) do
		if vim.fn.executable(exe) == 0 then
			vim.health.error(string.format("'%s' not found on path", exe))
			return
		end

		vim.health.ok(string.format("'%s' found on path", exe))
	end
end

return M
