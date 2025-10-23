local Fusion = require(script.Parent.Parent.Parent.Packages.fusion)

local methods = {}
methods.__index = methods

--Creates a link to a value.
function methods:LinkToInfluence(ObjectType: string, ObjectId: string, propertyName: string, value: Fusion.Value<Fusion.Scope<any>, any>)
    local scope: Fusion.Scope<any> = self._scope

    local InfluenceIndex = nil
    if ObjectId then
        InfluenceIndex = ObjectType .. "." .. ObjectId .. "." .. propertyName
    else
        InfluenceIndex = ObjectType .. "." .. propertyName
    end

    local value = self._influenceList[InfluenceIndex]

    if not value then
        return
    end


    value = scope:Computed(function(use, scope)
        
    end)
end

return function(scope: Fusion.Scope<any>, influenceList)
    local module = setmetatable({}, methods)
    module._influenceList = influenceList
    module._scope = scope

    return module
end