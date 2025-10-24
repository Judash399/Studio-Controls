local Fusion = require(script.Parent.Parent.Parent.Packages.fusion)

local methods = {}
methods.__index = methods

--Builds an influence key from the `ObjectType`, `ObjectId` and `propertyName`.
function methods.CombineKey(ObjectType: string, ObjectId: string, propertyName: string)
    --Keys aren't required to have an 'ObjectID' For example If the influence's input and/or output is an attribute, we don't need an ID for it. The attribute would just be on the object's root instance.
    if ObjectId then
        return ObjectType .. "." .. ObjectId .. "." .. propertyName
    else
        return ObjectType .. "." .. propertyName
    end
end


--Splits an influence key into each individual section.
function methods.DissectKey(key): {ObjectType: string, ObjectId: string, propertyName: string}
    local table = string.split(key, ".")

    --Keys aren't required to have an 'ObjectID' For example If the influence's input and/or output is an attribute, we don't need an ID for it. The attribute would just be on the object's root instance.
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
        error("DissectKey: invalid key format! Needs 2 or 3 segments, got " .. #table .. " segment(s), Key: '" .. key .. "'")
    end
end

--Returns a list of all the influences which value derives from the speified objects props. 
function methods:GetAllFromObject(ObjectType: string, ObjectId: string): {[string]: string}
    local matching = {}

    for i, influenceOutput in pairs(self._influenceList) do
        local keyInfo = self.DissectKey(i)

        if keyInfo.ObjectId == ObjectId and keyInfo.ObjectType == ObjectType then
            matching[i] = influenceOutput
        end
    end
    
    return matching
end

--Creates an `InfluenceManager` object.
return function(scope: Fusion.Scope<any>, influenceList)
    local module = setmetatable({}, methods)
    module._influenceList = influenceList
    module._scope = scope

    return module
end