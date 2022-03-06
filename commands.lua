local mainModule = require("interblelib")

local foo = (function()
    local t={}
    for i = 1, tonumber(0xFFFF), 1 do
        t[i] = nil
    end
    return t
end)

local variables = foo()

local currentPointer = 1

local function INTERB_ASSERT(expected, got, codeNumber)
    print(codeNumber)
    if expected ~= got then
        error(string.format("ERROR: Expected %s, got %s at %i", expected, got, codeNumber))
    end
end

local commands = {
    --Write out thing, or something
    ["0000"] = function(speicfier, number, codeNumber)
        local output = 0;

        if speicfier == "#" then
            output = variables[number]
        elseif speicfier == "x"  then
            output = string.char(number)
        elseif speicfier == "&"  then
            output = variables[number];
            
        end
        output = tostring(output)
        io.write(output)
        orderCode = orderCode + 1
    end,
    --Get user input
    ["0001"] = function(speicfier, number, codeNumber)
        --INTERB_ASSERT("#", value, codeNumber)
        --print(value)
        --printf("Hex: %s\n", "x"..string.sub(value, 2, #value))


        --print(newaddress, "is the value")
        local input = mainModule.input()
        variables[number] = input
        --currentPointer = tonumber(value)
        orderCode = orderCode + 1
    end,
    --Load avariable
    ["0002"] = function(speicfier, number, codeNumber)
        currentPointer = number

        orderCode = orderCode + 1
    end,
    --Override the current loaded variable
    ["0003"] = function(speicfier, number, codeNumber)
        local newValue = nil

        if speicfier == "#" then
            newValue = tonumber(number)
        elseif speicfier == "x" then
            newValue = string.char(number)
        end
        --print(currentPointer)
        --print(type(newValue))
        variables[currentPointer] = newValue
        print(type(variables[currentPointer]))
        orderCode = orderCode + 1
    end,
    --Jump
    ["0004"] = function(speicfier, number, codeNumber)
        orderCode = number
    end,
    --Increment
    ["0005"] = function(speicfier, number, codeNumber)

        variables[number] = variables[number] + 1
        orderCode = orderCode + 1
    end,
    --Decrement
    ["0006"] = function(speicfier, number, codeNumber)
        variables[number] = variables[number] + 1
        orderCode = orderCode + 1
    end,
    --Equality operator
    ["0007"] = function(speicfier, number, codeNumber)
        local variableValue = variables[currentPointer]
        local result = (number == variableValue)

        variables[currentPointer] = result
        orderCode = orderCode + 1
    end,

    ["000D"] = function(speicfier, number, codeNumber)
        mainModule.sleep(number)
        orderCode = orderCode + 1
    end
}

--[[]
local decoded = lib.split(str, "\n")


    while orderCode <= #decoded do
        local current = lib.split(v, ":")
        local command = current[1]
        local value = current[2]
        --print(v)
        validCommand[command](value, i)
    end
--]]

return commands