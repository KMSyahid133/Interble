local lib = {}

function _G.printf(str, ...) io.write(string.format(str, ...)) end

function lib.input()
    local userIn = ""

    while userIn == "" or userIn == " " do
        userIn = io.read("*line")
        --print(userIn)
    end

    --print(userIn)

    return userIn
end

function lib.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function lib.readFile(fileName)
    local sucess, content, file = pcall(function()
        local file = io.open(fileName)
        return file:read("*a"), file
    end)
    if sucess then
        io.close(file)
        return content
    else
        printf("WARNING: %s", content)
        return nil
    end
end

function lib.sleep(number)
    if number > 0 then 
        os.execute("ping -n " .. tonumber(number+1) .. " localhost > NUL") 
    end
end

return lib