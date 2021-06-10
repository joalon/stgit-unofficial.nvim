
stgit_bufh = nil
written_state = nil
top_index = nil
largest_index = nil

local function series()
    written_state = vim.fn.systemlist("stg series")

    for k, v in pairs(written_state) do
        if v:sub(1, 1) == ">" then
            top_index = k
        end
        largest_index = k
    end

    vim.api.nvim_command("split")
    stgit_bufh = vim.api.nvim_create_buf(true, true)

    vim.api.nvim_set_current_buf(stgit_bufh)
    vim.api.nvim_buf_set_name(stgit_bufh, "StGit Series")
    vim.api.nvim_buf_set_option(stgit_bufh, "buftype", "acwrite")
    vim.api.nvim_buf_set_lines(stgit_bufh, 0, -1, false, written_state)
    vim.api.nvim_win_set_cursor(0, {top_index, 0})

    -- When writing to the buffer, run 'execute_staged' to apply the changes
    vim.cmd("autocmd BufWriteCmd <buffer="..stgit_bufh.."> :lua require('stgit-unofficial').execute_staged()")
    vim.cmd("autocmd QuitPre <buffer="..stgit_bufh.."> :bdelete! "..stgit_bufh)
end

local function stage_pop()
    if top_index > 1 then
        local current_state = vim.api.nvim_buf_get_lines(stgit_bufh, 0, -1, false)

        current_state[top_index-1] = "> " .. current_state[top_index-1]:sub(3, -1)
        current_state[top_index] = "- " .. current_state[top_index]:sub(3, -1)

        top_index = top_index - 1
        vim.api.nvim_buf_set_lines(stgit_bufh, 0, -1, false, current_state)
    end
end

local function stage_push()
    if top_index < largest_index then
        local current_state = vim.api.nvim_buf_get_lines(stgit_bufh, 0, -1, false)

        current_state[top_index] = "+ " .. current_state[top_index]:sub(3, -1)
        current_state[top_index+1] = "> " .. current_state[top_index+1]:sub(3, -1)

        top_index = top_index + 1
        vim.api.nvim_buf_set_lines(stgit_bufh, 0, -1, false, current_state)
    end
end

local function stage_delete()
    local current_state = vim.api.nvim_buf_get_lines(stgit_bufh, 0, -1, false)
    local cursor_index = vim.api.nvim_win_get_cursor(0)[1]

    if cursor_index > 1 and current_state[cursor_index]:sub(1, 1) == ">" then
        current_state[cursor_index-1] = "> " .. current_state[cursor_index-1]:sub(3, -1)
    end
    current_state[cursor_index] = "D " .. current_state[cursor_index]:sub(3, -1)
    vim.api.nvim_buf_set_lines(stgit_bufh, 0, -1, false, current_state)
end

local function execute_staged()
    local index_is_dirty = next(vim.fn.systemlist("git diff --stat")) ~= nil

    if index_is_dirty then
        vim.api.nvim_command("!git stash")
    end

    local current_state = vim.api.nvim_buf_get_lines(stgit_bufh, 0, -1, false)

    for line, patch in pairs(current_state) do
        if patch:sub(1, 1) == "D" then
            local cmd = "!stg delete " .. patch:sub(3, -1)
            vim.api.nvim_command(cmd)
        end
    end

    for line, patch in pairs(current_state) do
        if patch:sub(1, 1) == ">" then
            cmd = "!stg goto " .. patch:sub(3, -1)
            vim.api.nvim_command(cmd)
            top_index = line
        end
        largest_index = line
    end

    if index_is_dirty then
        vim.api.nvim_command("!git stash pop")
    end

    written_state = vim.fn.systemlist("stg series")
    vim.api.nvim_buf_set_lines(stgit_bufh, 0, -1, false, written_state)
end

return {
    series         = series,
    stage_pop      = stage_pop,
    stage_push     = stage_push,
    stage_delete   = stage_delete,
    execute_staged = execute_staged
}
