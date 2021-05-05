
local function Series()
    local handle = io.popen("stg series")
    local status = handle:read("*a")
    handle:close()

    lines = {}
    for s in status:gmatch("[^\r\n]+") do
        table.insert(lines, s)
    end

    vim.api.nvim_command("split")
    vim.api.nvim_command("wincmd J")

    local bufh = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_set_current_buf(bufh)
    vim.api.nvim_buf_set_lines(bufh, 0, 0, false, lines)

end

return {
    Series = Series
}
