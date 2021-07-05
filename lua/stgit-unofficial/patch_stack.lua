patch_stack = {}

function patch_stack:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.top = 0

    for i,v in ipairs(o.patches) do
        patch_status = string.sub(v, 1, 1)

        if patch_status == '>' then
            self.top = i
        end
    end

    return o
end

function patch_stack:peek()
    if table.getn(self.patches) > 1 then
        return self.patches[self.top]
    end
end

function patch_stack:view()
    view = {}

    for i, v in ipairs(self.patches) do
        table.insert(view, v)
    end

    return view
end

function patch_stack:stage_pop()
    if self.top > 0 then
        current_patch =  self.patches[self.top]
        self.patches[self.top] = '-' .. string.sub(current_patch, 2, -1)

        self.top = self.top - 1

        if self.top > 0 then
            current_patch =  self.patches[self.top]
            self.patches[self.top] = '>' .. string.sub(current_patch, 2, -1)
        end
    else
        print("Error! Top is: " .. self.top)
    end
end

function patch_stack:stage_push()
    if self.top < table.getn(self.patches) then
        if self.top > 0 then
            current_patch = self.patches[self.top]
            self.patches[self.top] = '+' .. string.sub(current_patch, 2, -1)
        end

        self.top = self.top + 1

        current_patch = self.patches[self.top]
        self.patches[self.top] = '>' .. string.sub(current_patch, 2, -1)
    end
end

function patch_stack:stage_delete(index)
    if self.top == index then
        self:stage_pop()
    end
    patch = self.patches[index]
    self.patches[index] = "D " .. string.sub(patch, 3, -1)
end

function patch_stack:index_top()
    return self.top
end

function patch_stack:delete(patch)
    index = -1

    for i,v in ipairs(self.patches) do
        if v == patch then
            index = i
        end
    end

    if index ~= -1 then
        table.remove(self.patches, index)
        return true
    end
    return false
end

function patch_stack:_gen_stg_commands()
    cmds = {}

    table.insert(cmds, "pop --all")

    for i,v in ipairs(self.patches) do
        patch_status = string.sub(v, 1, 1)
        patch_name = string.sub(v, 3, -1)

        if patch_status == "+" then
            table.insert(cmds, "push " .. patch_name)
        elseif patch_status == ">" then
            table.insert(cmds, "push " .. patch_name)
        elseif patch_status == "D" then
            table.insert(cmds, "delete " .. patch_name)
        elseif patch_status == "-" then

        end
    end
    return cmds
end

function patch_stack:execute_staged(executor)
    reconcile_commands = self:_gen_stg_commands()

    for i,cmd in ipairs(reconcile_commands) do
        executor:exec(cmd)
    end
end

return patch_stack
