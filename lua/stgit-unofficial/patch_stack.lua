patch_stack = { i = 0 }

function patch_stack:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function patch_stack:addI()
    self.i = self.i + 1
end

function patch_stack:getI()
    return self.i
end

return patch_stack
