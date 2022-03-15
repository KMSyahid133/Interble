local lib = require("interblelib")
local validCommand = require("commands")

local project = {}

--Original pattern: "[%d%p0x%x%p]+"
--New pattern:
local pattern = "%x%x%x%x:[x&#c][0-9a-fA-F]+;"
--local pattern2 = "%x%x%x%x:&[0-9a-fA-F]+;"


local valid = function(foo)
    --print(foo)
    if validCommand[string.sub(foo, 1, 4)] then
        return true
    end
    return false
end



local function cleanUp(str)
    --print(str)
    local code = ""
    local count = 1
    for foo in string.gmatch(str, pattern) do
        count = count + 1
        if valid(foo) then
            code = code..foo.."\n"
        else
            error(string.format("ERROR: Command %s at %i is not valid", foo, count))
        end
        --end
    end

    return code
end

function project.getLength(fileName)
    local str = lib.readFile(fileName)
    local count = 0
    for foo in string.gmatch(str, pattern) do
        count = count + 1
    end

    return count
end

function project.execute(fileName)
    local str = lib.readFile(fileName)
    str = cleanUp(str)
    --print("Finished:\n"..str)
    _G.orderCode = 1
    local decoded = lib.split(str, "\n")
    while orderCode <= #decoded do
        local i = orderCode
        local v = decoded[i]

        local current = lib.split(v, ":")
        local command = current[1]
        local value = current[2]

        local specifier = string.sub(value, 1, 1)

        local number = 0
            
        if specifier == "#" then
            number = tonumber(string.sub(value, 2, string.len(value) - 1))
        else
            number = tonumber("0x"..string.sub(value, 2, string.len(value) - 1))
        end

        if validCommand[command] then
            validCommand[command](specifier, number, i)
        else
            error(string.format("ERROR: Command %i is not valid", command))
        end

    end
end

return project