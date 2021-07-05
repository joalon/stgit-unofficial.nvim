executor = {}

function executor:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    if o.bin == nil then
        self.bin = "stg "
    end
    return o
end

function executor:exec(cmd)
    vim.api.nvim_command("!" .. self.bin .. cmd)
end

return executor
