local mainModule = require("interblelib")

local hex = "h"
local char = "x"
local decimal = "#"
local address = "&"

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

        if speicfier == hex or speicfier == decimal then
            output = number
        elseif speicfier == char  then
            output = string.char(number)
        elseif speicfier == address  then
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
    --Save
    --abt: Override the current loaded variable
    ["0003"] = function(speicfier, number, codeNumber)
        local newValue = nil

        if speicfier == hex or speicfier == decimal then
            newValue = tonumber(number)
        elseif speicfier == char then
            newValue = string.char(number)
        elseif speicfier == address then
            newValue = variables[number]
        end
        --print(currentPointer)
        --print(type(newValue))
        variables[currentPointer] = newValue
        --print(type(variables[currentPointer]))
        orderCode = orderCode + 1
    end,
    --Jump
    ["0004"] = function(specifier, number, codeNumber)
        orderCode = number
    end,
    --Increment
    ["0005"] = function(specifier, number, codeNumber)

        variables[number] = variables[number] + 1
        orderCode = orderCode + 1
    end,
    --Decrement
    ["0006"] = function(specifier, number, codeNumber)
        variables[number] = variables[number] + 1
        orderCode = orderCode + 1
    end,
    --Equality operator
    ["0007"] = function(specifier, number, codeNumber)
        --print("Num: "..number.." Order: "..orderCode)
        local variableValue = tonumber(variables[currentPointer])
        local result = (variableValue == number)
        
        variables[currentPointer] = result
        orderCode = orderCode + 1
    end,
    --Not equal to
    ["0008"] = function(specifier, number, codeNumber)
        local variableValue = variables[currentPointer]
        local result = (variableValue ~= number)

        variables[currentPointer] = result
        orderCode = orderCode + 1
    end,
    --More than
    ["0009"] = function(specifier, number, codeNumber)
        local variableValue = variables[currentPointer]
        local result = (variableValue > number)

        variables[currentPointer] = result
        orderCode = orderCode + 1
    end,
    --Less than
    ["000A"] = function(specifier, number, codeNumber)
        local variableValue = variables[currentPointer]
        local result = (variableValue < number)

        variables[currentPointer] = result
        orderCode = orderCode + 1
    end,
    --Less or equal to
    ["000B"] = function(specifier, number, codeNumber)
        local variableValue = variables[currentPointer]
        local result = (variableValue <= number)

        variables[currentPointer] = result
        orderCode = orderCode + 1
    end,
    --More or equal to
    ["000C"] = function(specifier, number, codeNumber)
        local variableValue = variables[currentPointer]
        local result = (variableValue >= number)

        variables[currentPointer] = result
        orderCode = orderCode + 1
    end,
    --Sleep
    ["000D"] = function(specifier, number, codeNumber)
        mainModule.sleep(number)
        orderCode = orderCode + 1
    end,
    --if statement
    ["000E"] = function(specifier, number, codeNumber)
        local value = variables[currentPointer]

        if string.match(type(value), "boolean") then
            --print(value)
            if not value then
                orderCode = number
            else
                orderCode = orderCode + 1
            end
        else
            error(string.format("I WANT BOOLEAN NOT %s", type(value)))
        end

    end,
    --Addition
    ["000F"] = function(specifier, number, codeNumber)
        
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