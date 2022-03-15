local interble = require("interble")
local main = require("interblelib")

local function mysplit(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

local function Main()
    io.write(">")
    local input = main.input()
    local command = mysplit(input, " ")
    if command[1] == "interble" then
        if string.match(command[2], ".txt") then
            interble.execute(command[2])
        elseif command[2] == "-l" then
            if string.match(command[3], ".txt") then
                print(interble.getLength(command[3]))
            else
                print("bad argument 3")
                main()
            end
           
        else
            print("Bad 2 argument")
            main()
        end
    else
    end
end

Main()