local function compileInstanceTree(root): {any}
    local t = {}

    for _, child in ipairs(root:GetChildren()) do
        local index = child.Name

        --Turn it into a number if it can be a number. (Makes it cleaner)
        if tonumber(index) then
            index = tonumber(index)
        end

        if child:IsA "ValueBase" then
            t[index] = child.Value
        elseif child:IsA "Folder" then
            t[index] = compileInstanceTree(child)
        else
            t[index] = child
        end
    end

    return t
end

return function(Root: Folder)
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
    local ControllerData = compileInstanceTree(ControlsFolder)
    local InfluenceData = compileInstanceTree(InfluencesFolder)

    return true, {
        Controllers = ControllerData,
        Influences = InfluenceData,
        Template = Template
    }
end