
local function StgStatus()
    local handle = io.popen("stg status")
    local result = handle:read("*a")
    handle:close()

    print(result)
end

return {
    StgStatus = StgStatus
}
