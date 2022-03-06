local lib = require("interblelib")
local validCommand = require("commands")

local project = {}

--Original pattern: "[%d%p0x%x%p]+"
--New pattern:
local pattern = "%x%x%x%x:[x&#][0-9a-fA-F]+;"
--local pattern2 = "%x%x%x%x:&[0-9a-fA-F]+;"


local validSyntax = function(foo)
    --print(foo)
     if string.match(foo, pattern) then
         return true
     end
     return false
end



local function cleanUp(str)
    --print(str)
    local code = ""

    for foo in string.gmatch(str, pattern) do
        --print(foo)
        --if validSyntax(foo) then
        code = code..foo.."\n"
        --end
    end

    return code
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
        --print(v)
        --print(v)
        if validCommand[command] then
            validCommand[command](specifier, number, i)
        else
            error(string.format("ERROR: Command %i is not valid", command))
        end
    end
end

return project