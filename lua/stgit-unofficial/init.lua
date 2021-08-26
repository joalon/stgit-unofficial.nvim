
local patch_stack = require('stgit-unofficial.patch_stack')
local executor = require('stgit-unofficial.executor')

local stgit_bufh = nil
local patches = nil

local function setup()
    print("Hello, World!")
end

local function exec(args)
    command = "stg"

    for i,v in ipairs(args) do
        command = command .. " " .. v
    end

    vim.api.nvim_command("!" .. command)
end

local function series()
    written_state = vim.fn.systemlist("stg series")
    patches = patch_stack:new({ patches = written_state })

    vim.api.nvim_command("split")
    stgit_bufh = vim.api.nvim_create_buf(true, true)

    vim.api.nvim_set_current_buf(stgit_bufh)
    vim.api.nvim_buf_set_name(stgit_bufh, "StGit Series")
    vim.api.nvim_buf_set_option(stgit_bufh, "buftype", "acwrite")
    vim.api.nvim_buf_set_lines(stgit_bufh, 0, -1, false, patches:view())
    vim.api.nvim_win_set_cursor(0, {patches:index_top(), 0})

    -- When writing to the buffer, run 'execute_staged' to apply the changes
    vim.cmd("autocmd BufWriteCmd <buffer="..stgit_bufh.."> :lua require('stgit-unofficial').execute_staged()")
    vim.cmd("autocmd QuitPre <buffer="..stgit_bufh.."> :bdelete! "..stgit_bufh)

    vim.api.nvim_buf_set_keymap(stgit_bufh, 'n', 'dd', ":lua require('stgit-unofficial').stage_delete()<cr>", {})
end

local function stage_pop()
    patches:stage_pop()
    vim.api.nvim_buf_set_lines(stgit_bufh, 0, -1, false, patches:view())
end

local function stage_push()
    patches:stage_push()
    vim.api.nvim_buf_set_lines(stgit_bufh, 0, -1, false, patches:view())
end

local function stage_delete()
    local cursor_index = vim.api.nvim_win_get_cursor(0)[1]
    patches:stage_delete(cursor_index)
    vim.api.nvim_buf_set_lines(stgit_bufh, 0, -1, false, patches:view())
end

local function execute_staged()
    local index_is_dirty = next(vim.fn.systemlist("git diff --stat")) ~= nil

    if index_is_dirty then
        vim.api.nvim_command("!git stash")
    end

    patches:execute_staged(executor:new())

    if index_is_dirty then
        vim.api.nvim_command("!git stash pop")
    end

    written_state = vim.fn.systemlist("stg series")
    patches = patch_stack:new({ patches = written_state })

    vim.api.nvim_buf_set_lines(stgit_bufh, 0, -1, false, patches:view())
end

return {
    exec           = exec,
    setup          = setup,
    series         = series,
    stage_pop      = stage_pop,
    stage_push     = stage_push,
    stage_delete   = stage_delete,
    execute_staged = execute_staged
}
