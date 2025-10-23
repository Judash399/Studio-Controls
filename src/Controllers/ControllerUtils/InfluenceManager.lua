local Fusion = require(script.Parent.Parent.Parent.Packages.fusion)

local methods = {}
methods.__index = methods

function methods.CombineKey(ObjectType: string, ObjectId: string, propertyName: string)
    local key = nil
    if ObjectId then
        key = ObjectType .. "." .. ObjectId .. "." .. propertyName
    else
        key = ObjectType .. "." .. propertyName
    end

    return key
end

function methods.DesectKey(key): {ObjectType: string, ObjectId: string, propertyName: string}
    local table = string.split(key, ".")

    if #table == 3 then
        return {
            ObjectType = table[1],
            ObjectId = table[2],
            propertyName = table[3],
        }
    elseif #table == 2 then
        return {
            ObjectType = table[1],
            propertyName = table[2],
        }
    else
        error("DesectKey: invalid key format. Expected 'ObjectType.propertyName' or 'ObjectType.ObjectId.propertyName', got " .. #table .. " segment(s): '" .. key .. "'")
    end
end

--Returns a list of all the influences which value derives from the speified objects props. 
function methods:GetAllFromObject(ObjectType: string, ObjectId: string): {[string]: string}
    local matching = {}

    for i, influenceOutput in pairs(self._influenceList) do
        local keyInfo = self.DesectKey(i)

        if keyInfo.ObjectId == ObjectId and keyInfo.ObjectType == ObjectType then
            matching[i] = influenceOutput
        end
    end
    
    return matching
end

return function(scope: Fusion.Scope<any>, influenceList)
    local module = setmetatable({}, methods)
    module._influenceList = influenceList
    module._scope = scope

    return module
end