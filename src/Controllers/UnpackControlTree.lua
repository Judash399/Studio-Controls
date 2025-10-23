local Fusion = require(script.Parent.Parent.Packages.fusion)

local function compileInstanceTree(root, scope): {any}
    local table = Fusion.scoped()

    for _, child in ipairs(root:GetChildren()) do
        local index = child.Name

        --Turn it into a number if it can be a number. (Makes it cleaner)
        if tonumber(index) then
            index = tonumber(index)
        end

        if child:IsA "ValueBase" then
            table[index] = Fusion.Value(scope, child.Value)
        elseif child:IsA "Folder" then
            table[index] = compileInstanceTree(child, scope)
        else
            table[index] = child
        end
    end

    return table
end

return function(Root: Folder, scope: Fusion.Scope<any>)
    local ControlsFolder = Root:FindFirstChild("Controls")

    if not ControlsFolder then
        return false, "No Controls folder!"
    end

    local InfluencesFolder = Root:FindFirstChild("Influences")

    if not InfluencesFolder then
        return false, "No Influences folder!"
    end

    local Template = Root:FindFirstChild("Template")

    if not Template then
        return false, "No Template!"
    end

    --More Valid templates will likely be added in the future.
    local ValidTemplateTypes = {
        "Model",
        "BasePart",
    }

    if not table.find(ValidTemplateTypes, Template.ClassName) then
        return false, "Invalid Template Type!"
    end


    --We would likely do some logic over here to check if the controls and influences are correctly defined, as of right now it just reads the data blindly.
    local ControllerData = compileInstanceTree(ControlsFolder, scope)
    local InfluenceData = compileInstanceTree(InfluencesFolder, scope)

    return true, {
        Controllers = ControllerData,
        Influences = InfluenceData,
        Template = Template
    }
end